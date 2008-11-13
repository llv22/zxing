/*
 * Copyright 2008 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.zxing.common.reedsolomon;

import junit.framework.TestCase;

import java.util.BitSet;
import java.util.Random;

/**
 * @author srowen@google.com (Sean Owen)
 */
abstract class AbstractReedSolomonTestCase extends TestCase {

  static void corrupt(int[] received, int howMany, Random random) {
    BitSet corrupted = new BitSet(received.length);
    for (int j = 0; j < howMany; j++) {
      int location = random.nextInt(received.length);
      if (corrupted.get(location)) {
        j--;
      } else {
        corrupted.set(location);
        received[location] = (received[location] + 1 + random.nextInt(255)) & 0xFF;
      }
    }
  }

}