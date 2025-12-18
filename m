Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D204D32E735
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Dec 2025 13:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766063719; cv=none; b=lmcYmNEGfr4vAVXpt+nYJc8WXla4mUOJSahAyx54NQUL54vEB8vf2nRsL57rEdJM/UQnT+/0yxV8W2G3qJW11kVXvMY/OuHDyLoF+Qc/n5KQJmVrbrx2gUoEmxRpC/uOIwj5GfXcQdxjpOFvzjZtZwYFjhTZuyDeKw1Vi39VUlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766063719; c=relaxed/simple;
	bh=rMmWxUejitgf+XgJ5dYANgAY98wa0jTWm2OKU1VLdxo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=oHAeH/CvGmP/zG7O8hU0KOLmY768QyBjD9JB+5P5mWX3M266vKWorNlXTfnchx0tk+F0wNSdWZV+1z47S1B8+IOOyGIndRckuZka9VJuns3TiJsiwLb7II5W+ukRpVbZd3pzNYgEIURznfQwXsl/VwINF9CX9SuDbAmJZke5m5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bmcnyTZV; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bmcnyTZV"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-34c902f6845so841348a91.2
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Dec 2025 05:15:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766063717; x=1766668517; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3yF3p3jb9cPXkBZGsDg878KyLPgZ2F3HGgYotSoa6QY=;
        b=bmcnyTZV5Ax6B/bvVziTB6sbo0asE8OGTkrUtvXTCeK3tSAkTL0jt1AZco8MADBVnI
         nZi+wbSOFFWnorVPZhGKzOMoLg+FgUjr7kb/OB9lMFqBy/Rh6mc1nXRY1z/2OajWH1WS
         SCd+wwNaLV4P3VCGVQcaZ/cVGy7/3CAe7HsUTckDHdecqrUmbXOLFp6V9gcZH1OGKZKu
         K00u7m5Iq5b7DfRjwrmodLD9xM442nOryt6Llj4mAZ5jovdyWK3cptRIVUQllHUvm6/d
         2NE1Jjkt//wTNGQaOG3u43cHGVqPHRBb3hciY9Gr3rDNnFlULBWhvfs2Fh/bM6UNEzMq
         Xjew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766063717; x=1766668517;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3yF3p3jb9cPXkBZGsDg878KyLPgZ2F3HGgYotSoa6QY=;
        b=imNRU0Lz5YSNXJsLyY+VMBjOLD8pdTg6ueJMydWAcOXkJA1wyN8Ck0ulcF61HmrTc3
         +WXRuBRmA4FDyFwR8QLJYebTE8HTnimfGRbtxykmzch1yTxrVQm1pSBOLDy4djo0wOb+
         AWl1aoOvyRERhGDU7f60afs8SuuYL1BrMZ8L/Zsrqpq5sCnjNA1CMeYcFyzbBk8UvTM+
         ksX8idHeELU5l/bIz8obLEAaKNcKvzilmUA5m/JAYvlPAUUvUvpxP0/lLocBp7Pn2QP3
         77Op7T8Of5iAB14WdlFhKwr3fT0hdV6T4CvIw0wEKFLqjsk2VY5lg0ECsEgM4fRaEw/S
         hMDQ==
X-Gm-Message-State: AOJu0YzHFLz4T4J76uzC6w0o1f+DrB/CgKRiQVN4IV+za0dhhEF/eKaX
	fLqa5kGitGUxBW83cE9U31eLsKorYr1fDaLQMrE5dK3QN7cFEfnXsnEDPz8gNfKL8bmnppJMS1f
	A1FTQvHaRudWJ9wi4YSH4UdjPW3aT3RErg2JoGvI6BCci
X-Gm-Gg: AY/fxX4Hl46FtdXxHdZQshVW2PMcDm053X5BvHX0Ve6rGJ9moQRQ/EYr86gtqSIyK7z
	CJ0I+Yfjr7TGqqxOdCq1plpjFS4/cZ079K+2xmoC5xH7kYNmZkRFRtARESxXSCT9wqL2qGPwgdy
	1Xh9el/RuKp9VnkoXzkfy1o881G3rfOz7l7oGuJx0XS9D0JRW31wNrE+LeHAxnECtjT32d7ZQbQ
	ybVDNxy+LpDm6vcatAsT0RYgudYVfgWBO7X2dzOMbRLWP6CGdpGFzlvLnzqaipBEIELifeT9P7r
	833kHqQNiGRONwsIGKiKBuf3
X-Google-Smtp-Source: AGHT+IF/eg3RansAVSTkdncu8EJ59H57X1AKZovU3C1AoVHmYVvNZ7F440m7L62b8HcxUh3uhZYChIFyOW6BrjfxGKM=
X-Received: by 2002:a17:90b:3912:b0:33b:be31:8194 with SMTP id
 98e67ed59e1d1-34abd7bae4bmr18206527a91.34.1766063716697; Thu, 18 Dec 2025
 05:15:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Ilia Kashintsev <ilia.kashintsev@gmail.com>
Date: Thu, 18 Dec 2025 16:15:05 +0300
X-Gm-Features: AQt7F2ovA30wrvNAq0G2s6aI6t0R_wzN9IkO5tSsAOFf2-TnHqcEFSjZwcF0Ufg
Message-ID: <CAF6ebR70NXKv54uEE=kGC2O9tg5K+LoB5gZCm7tKJJaJRGLZcg@mail.gmail.com>
Subject: Global buffer overflow in parse_ip6_mask()
To: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello maintainers! I have found several global buffer overflows in
useful_functions.c

They both occur in the function parse_ip6_mask() and are caused by
unconditionally writing to p[16].

The first overflow occurs when bits is equal to 128,
which causes p[bits / 8] = 0xff << (8 - (bits & 7)); to write at p[16].

The second overflow occurs when bits is equal to 8,
which causes memset(p + (bits / 8) + 1, 0, (128 - bits) / 8); to write
15 bytes starting at p + 2, which leads to the same issue.

Sanitizer output for the first overflow:

==4013==ERROR: AddressSanitizer: global-buffer-overflow on address
0x55972a77b5f0 at pc 0x559729dd1d13 bp 0x7ffed4db8810 sp
0x7ffed4db8808
WRITE of size 1 at 0x55972a77b5f0 thread T0
    #0 0x559729dd1d12 in parse_ip6_mask
/orig/pkg-ebtables/useful_functions.c:368:15
    #1 0x559729dd18e7 in ebt_parse_ip6_address
/orig/pkg-ebtables/useful_functions.c:392:14
    #2 0x559729dcfdc2 in main /orig/pkg-ebtables/reproduction.c:40:5
    #3 0x7f6d398ee249 in __libc_start_call_main
csu/../sysdeps/nptl/libc_start_call_main.h:58:16
    #4 0x7f6d398ee304 in __libc_start_main csu/../csu/libc-start.c:360:3
    #5 0x559729cf0450 in _start
(/orig/pkg-ebtables/reproduction+0x2f450) (BuildId:
b1b8105cc025dc9ed11bd734af2fe28338caec61)

0x55972a77b5f0 is located 16 bytes before global variable
'numeric_to_addr.ap' defined in
'/orig/pkg-ebtables/useful_functions.c:341' (0x55972a77b600) of size
16
0x55972a77b5f0 is located 0 bytes after global variable
'parse_ip6_mask.maskaddr' defined in
'/orig/pkg-ebtables/useful_functions.c:351' (0x55972a77b5e0) of size
16
SUMMARY: AddressSanitizer: global-buffer-overflow
/orig/pkg-ebtables/useful_functions.c:368:15 in parse_ip6_mask
Shadow bytes around the buggy address:
  0x55972a77b300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x55972a77b380: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x55972a77b400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x55972a77b480: 00 00 00 00 04 f9 f9 f9 04 f9 f9 f9 00 00 04 f9
  0x55972a77b500: f9 f9 f9 f9 00 00 00 00 00 00 03 f9 f9 f9 f9 f9
=>0x55972a77b580: 00 00 00 00 00 00 04 f9 f9 f9 f9 f9 00 00[f9]f9
  0x55972a77b600: 00 00 f9 f9 00 00 00 00 00 f9 f9 f9 04 f9 f9 f9
  0x55972a77b680: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x55972a77b700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x55972a77b780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x55972a77b800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Shadow byte legend (one shadow byte represents 8 application bytes):
  Addressable:           00
  Partially addressable: 01 02 03 04 05 06 07
  Heap left redzone:       fa
  Freed heap region:       fd
  Stack left redzone:      f1
  Stack mid redzone:       f2
  Stack right redzone:     f3
  Stack after return:      f5
  Stack use after scope:   f8
  Global redzone:          f9
  Global init order:       f6
  Poisoned by user:        f7
  Container overflow:      fc
  Array cookie:            ac
  Intra object redzone:    bb
  ASan internal:           fe
  Left alloca redzone:     ca
  Right alloca redzone:    cb
==4013==ABORTING


Sanitizer output for the second overflow:

==4011==ERROR: AddressSanitizer: global-buffer-overflow on address
0x633d6f5115f0 at pc 0x633d6eb23705 bp 0x7ffc5604fd70 sp
0x7ffc5604f540
WRITE of size 15 at 0x633d6f5115f0 thread T0
    #0 0x633d6eb23704 in __asan_memset
(/orig/pkg-ebtables/reproduction+0xcc704) (BuildId:
b1b8105cc025dc9ed11bd734af2fe28338caec61)
    #1 0x633d6eb67cb6 in parse_ip6_mask
/orig/pkg-ebtables/useful_functions.c:367:3
    #2 0x633d6eb678e7 in ebt_parse_ip6_address
/orig/pkg-ebtables/useful_functions.c:392:14
    #3 0x633d6eb65dc2 in main /orig/pkg-ebtables/reproduction.c:40:5
    #4 0x7e04737e6249 in __libc_start_call_main
csu/../sysdeps/nptl/libc_start_call_main.h:58:16
    #5 0x7e04737e6304 in __libc_start_main csu/../csu/libc-start.c:360:3
    #6 0x633d6ea86450 in _start
(/orig/pkg-ebtables/reproduction+0x2f450) (BuildId:
b1b8105cc025dc9ed11bd734af2fe28338caec61)

0x633d6f5115f0 is located 16 bytes before global variable
'numeric_to_addr.ap' defined in
'/orig/pkg-ebtables/useful_functions.c:341' (0x633d6f511600) of size
16
0x633d6f5115f0 is located 0 bytes after global variable
'parse_ip6_mask.maskaddr' defined in
'/orig/pkg-ebtables/useful_functions.c:351' (0x633d6f5115e0) of size
16
SUMMARY: AddressSanitizer: global-buffer-overflow
(/orig/pkg-ebtables/reproduction+0xcc704) (BuildId:
b1b8105cc025dc9ed11bd734af2fe28338caec61) in __asan_memset
Shadow bytes around the buggy address:
  0x633d6f511300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x633d6f511380: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x633d6f511400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x633d6f511480: 00 00 00 00 04 f9 f9 f9 04 f9 f9 f9 00 00 04 f9
  0x633d6f511500: f9 f9 f9 f9 00 00 00 00 00 00 03 f9 f9 f9 f9 f9
=>0x633d6f511580: 00 00 00 00 00 00 04 f9 f9 f9 f9 f9 00 00[f9]f9
  0x633d6f511600: 00 00 f9 f9 00 00 00 00 00 f9 f9 f9 04 f9 f9 f9
  0x633d6f511680: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x633d6f511700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x633d6f511780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x633d6f511800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Shadow byte legend (one shadow byte represents 8 application bytes):
  Addressable:           00
  Partially addressable: 01 02 03 04 05 06 07
  Heap left redzone:       fa
  Freed heap region:       fd
  Stack left redzone:      f1
  Stack mid redzone:       f2
  Stack right redzone:     f3
  Stack after return:      f5
  Stack use after scope:   f8
  Global redzone:          f9
  Global init order:       f6
  Poisoned by user:        f7
  Container overflow:      fc
  Array cookie:            ac
  Intra object redzone:    bb
  ASan internal:           fe
  Left alloca redzone:     ca
  Right alloca redzone:    cb
==4011==ABORTING


Reproduction:
1) Build the project with sanitizers:

export CFLAGS="-g -O0 -fsanitize=address"
export CXXFLAGS="-g -O0 -fsanitize=address"
export CC=clang
export CXX=clang++

autoreconf -fi
./configure --enable-static --disable-shared
make

2) Build the example:

clang -g -O0 -fsanitize=address -o reproduction reproduction.c
libebtc_la-useful_functions.o ./.libs/libebtc.a

reproduction.c:

#include <stdio.h>
#include <unistd.h>

#include <arpa/inet.h>
#include <netinet/in.h>

#if defined(__linux__)
#  include <netinet/ether.h>
#else
#  include <net/ethernet.h>
#  include <arpa/inet.h>
#  include <netinet/ether.h>
#endif

void ebt_parse_ip6_address(char *address, struct in6_addr *addr,
struct in6_addr *msk);

int main(void) {
    unsigned char buf[256];
    ssize_t len;

    len = read(STDIN_FILENO, buf, sizeof(buf));
    if (len <= 0) {
        if (len == 0) {
            return 0;
        } else {
            perror("read");
            return 1;
        }
    }

    if (len < sizeof(buf)) {
        buf[len] = '\0';
    } else {
        buf[sizeof(buf) - 1] = '\0';
    }

    struct in6_addr addr = {0};
    struct in6_addr msk = {0};

    ebt_parse_ip6_address((char *)buf, &addr, &msk);

    return 0;
}


3) Launch the example with the provided inputs:

./reproduction < input1.txt
./reproduction < input2.txt

To generate input1.txt and input2.txt copy the corresponding text into
bs64_1.txt and bs64_2.txt and then run:

base64 -d bs64_1.txt > input1.txt
base64 -d bs64_2.txt > input2.txt

bs64_1.txt:
WTEvLzESES8vMTI4AAAAWQAAAAExEhIfAIAADgBk/wB/8Q4mLwAAAAAAAAEAMTIxDg4=

bs64_2.txt:
WWxsN4BvUTYg2GxsLzgADg==


Suggested fix:

It is proposed to handle 2 cases separately, keeping current behaviour
when bits % 8 != 0 and avoiding it when bits % 8 == 0. Nevertheless, i
can't be sure this fix is totally correct.

diff --git a/useful_functions.c b/useful_functions.c
index 133ae2f..a8dfcbc 100644
--- a/useful_functions.c
+++ b/useful_functions.c
@@ -364,8 +364,12 @@ static struct in6_addr *parse_ip6_mask(char *mask)
        if (bits != 0) {
                char *p = (char *)&maskaddr;
                memset(p, 0xff, bits / 8);
-               memset(p + (bits / 8) + 1, 0, (128 - bits) / 8);
-               p[bits / 8] = 0xff << (8 - (bits & 7));
+               if (bits & 7) {
+                       memset(p + (bits / 8) + 1, 0, (128 - bits) / 8);
+                       p[bits / 8] = 0xff << (8 - (bits & 7));
+               } else {
+                       memset(p + (bits / 8), 0, (128 - bits) / 8);
+               }
                return &maskaddr;
        }
