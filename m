Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D41C8C433DB
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 22:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A960E65253
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 22:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhCHWEb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Mar 2021 17:04:31 -0500
Received: from static-213-198-238-194.adsl.eunet.rs ([213.198.238.194]:51042
        "EHLO fx.arvanta.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbhCHWEB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Mar 2021 17:04:01 -0500
X-Greylist: delayed 3695 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Mar 2021 17:04:00 EST
Received: from arya.arvanta.net (arya.arvanta.net [10.5.1.6])
        by fx.arvanta.net (Postfix) with ESMTP id 5CB3415C1F
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Mar 2021 22:02:20 +0100 (CET)
Date:   Mon, 8 Mar 2021 22:02:19 +0100
From:   Milan =?utf-8?Q?P=2E_Stani=C4=87?= <mps@arvanta.net>
To:     netfilter-devel@vger.kernel.org
Subject: xtables-addons-3.17 fail build on armv7 with musl libc
Message-ID: <YEaQ2wXhLxG69EQg@arya.arvanta.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

[ I'm not subscribed so please Cc include me in reply ]

I'm trying to fix build of xtables-addons-3.17 on Alpine Linux which is
based on musl libc. Build pass on our x86, x86_64, aarch64, ppc64le and
s390x arches but fails on armv7. Here is excerpt from build log.

-------------------------
  CC [M]  /home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/xt_ipp2p.o
In file included from ./arch/arm/include/asm/div64.h:127,
                 from ./include/linux/kernel.h:19,
                 from ./include/linux/list.h:9,
                 from ./include/linux/module.h:12,
                 from /home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:10:
/home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c: In function 'has_logged_during_this_minute':
./include/asm-generic/div64.h:226:28: warning: comparison of distinct pointer types lacks a cast
  226 |  (void)(((typeof((n)) *)0) == ((uint64_t *)0)); \
      |                            ^~
/home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:346:9: note: in expansion of macro 'do_div'
  346 |  return do_div(y, 60) == do_div(x, 60);
      |         ^~~~~~
In file included from ./include/linux/kernel.h:11,
                 from ./include/linux/list.h:9,
                 from ./include/linux/module.h:12,
                 from /home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:10:
./include/asm-generic/div64.h:239:25: warning: right shift count >= width of type [-Wshift-count-overflow]
  239 |  } else if (likely(((n) >> 32) == 0)) {  \
      |                         ^~
./include/linux/compiler.h:77:40: note: in definition of macro 'likely'
   77 | # define likely(x) __builtin_expect(!!(x), 1)
      |                                        ^
/home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:346:9: note: in expansion of macro 'do_div'
  346 |  return do_div(y, 60) == do_div(x, 60);
      |         ^~~~~~
In file included from ./arch/arm/include/asm/div64.h:127,
                 from ./include/linux/kernel.h:19,
                 from ./include/linux/list.h:9,
                 from ./include/linux/module.h:12,
                 from /home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:10:
./include/asm-generic/div64.h:243:22: error: passing argument 1 of '__div64_32' from incompatible pointer type [-Werror=incompatible-pointer-types]
  243 |   __rem = __div64_32(&(n), __base); \
      |                      ^~~~
      |                      |
      |                      long unsigned int *
/home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:346:9: note: in expansion of macro 'do_div'
  346 |  return do_div(y, 60) == do_div(x, 60);
      |         ^~~~~~
In file included from ./include/linux/kernel.h:19,
                 from ./include/linux/list.h:9,
                 from ./include/linux/module.h:12,
                 from /home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:10:
./arch/arm/include/asm/div64.h:33:45: note: expected 'uint64_t *' {aka 'long long unsigned int *'} but argument is of type 'long unsigned int *'
   33 | static inline uint32_t __div64_32(uint64_t *n, uint32_t base)
      |                                   ~~~~~~~~~~^
In file included from ./arch/arm/include/asm/div64.h:127,
                 from ./include/linux/kernel.h:19,
                 from ./include/linux/list.h:9,
                 from ./include/linux/module.h:12,
                 from /home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:10:
./include/asm-generic/div64.h:226:28: warning: comparison of distinct pointer types lacks a cast
  226 |  (void)(((typeof((n)) *)0) == ((uint64_t *)0)); \
      |                            ^~
/home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:346:26: note: in expansion of macro 'do_div'
  346 |  return do_div(y, 60) == do_div(x, 60);
      |                          ^~~~~~
In file included from ./include/linux/kernel.h:11,
                 from ./include/linux/list.h:9,
                 from ./include/linux/module.h:12,
                 from /home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:10:
./include/asm-generic/div64.h:239:25: warning: right shift count >= width of type [-Wshift-count-overflow]
  239 |  } else if (likely(((n) >> 32) == 0)) {  \
      |                         ^~
./include/linux/compiler.h:77:40: note: in definition of macro 'likely'
   77 | # define likely(x) __builtin_expect(!!(x), 1)
      |                                        ^
/home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:346:26: note: in expansion of macro 'do_div'
  346 |  return do_div(y, 60) == do_div(x, 60);
      |                          ^~~~~~
In file included from ./arch/arm/include/asm/div64.h:127,
                 from ./include/linux/kernel.h:19,
                 from ./include/linux/list.h:9,
                 from ./include/linux/module.h:12,
                 from /home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:10:
./include/asm-generic/div64.h:243:22: error: passing argument 1 of '__div64_32' from incompatible pointer type [-Werror=incompatible-pointer-types]
  243 |   __rem = __div64_32(&(n), __base); \
      |                      ^~~~
      |                      |
      |                      long unsigned int *
/home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:346:26: note: in expansion of macro 'do_div'
  346 |  return do_div(y, 60) == do_div(x, 60);
      |                          ^~~~~~
In file included from ./include/linux/kernel.h:19,
                 from ./include/linux/list.h:9,
                 from ./include/linux/module.h:12,
                 from /home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:10:
./arch/arm/include/asm/div64.h:33:45: note: expected 'uint64_t *' {aka 'long long unsigned int *'} but argument is of type 'long unsigned int *'
   33 | static inline uint32_t __div64_32(uint64_t *n, uint32_t base)
      |                                   ~~~~~~~~~~^
In file included from ./arch/arm/include/asm/div64.h:127,
                 from ./include/linux/kernel.h:19,
                 from ./include/linux/list.h:9,
                 from ./include/linux/module.h:12,
                 from /home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:10:
/home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c: In function 'has_secret':
./include/asm-generic/div64.h:226:28: warning: comparison of distinct pointer types lacks a cast
  226 |  (void)(((typeof((n)) *)0) == ((uint64_t *)0)); \
      |                            ^~
/home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:740:14: note: in expansion of macro 'do_div'
  740 |  epoch_min = do_div(x, 60);
      |              ^~~~~~
In file included from ./include/linux/kernel.h:11,
                 from ./include/linux/list.h:9,
                 from ./include/linux/module.h:12,
                 from /home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:10:
./include/asm-generic/div64.h:239:25: warning: right shift count >= width of type [-Wshift-count-overflow]
  239 |  } else if (likely(((n) >> 32) == 0)) {  \
      |                         ^~
./include/linux/compiler.h:77:40: note: in definition of macro 'likely'
   77 | # define likely(x) __builtin_expect(!!(x), 1)
      |                                        ^
/home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:740:14: note: in expansion of macro 'do_div'
  740 |  epoch_min = do_div(x, 60);
      |              ^~~~~~
In file included from ./arch/arm/include/asm/div64.h:127,
                 from ./include/linux/kernel.h:19,
                 from ./include/linux/list.h:9,
                 from ./include/linux/module.h:12,
                 from /home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:10:
./include/asm-generic/div64.h:243:22: error: passing argument 1 of '__div64_32' from incompatible pointer type [-Werror=incompatible-pointer-types]
  243 |   __rem = __div64_32(&(n), __base); \
      |                      ^~~~
      |                      |
      |                      long unsigned int *
/home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:740:14: note: in expansion of macro 'do_div'
  740 |  epoch_min = do_div(x, 60);
      |              ^~~~~~
In file included from ./include/linux/kernel.h:19,
                 from ./include/linux/list.h:9,
                 from ./include/linux/module.h:12,
                 from /home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:10:
./arch/arm/include/asm/div64.h:33:45: note: expected 'uint64_t *' {aka 'long long unsigned int *'} but argument is of type 'long unsigned int *'
   33 | static inline uint32_t __div64_32(uint64_t *n, uint32_t base)
      |                                   ~~~~~~~~~~^
  CC [M]  /home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/xt_ipv4options.o
  CC [M]  /home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/xt_length2.o
cc1: some warnings being treated as errors
make[3]: *** [scripts/Makefile.build:279: /home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.o] Error 1
make[2]: *** [scripts/Makefile.build:496: /home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [Makefile:1801: /home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions] Error 2
make[1]: Leaving directory '/usr/src/linux-headers-5.10.20-0-lts'
make: *** [Makefile:465: modules] Error 2
>>> ERROR: xtables-addons-lts: build failed
>
-------------------------

I crated this patch just below to fix this:
-------------------------

--- a/extensions/pknock/xt_pknock.c	2021-02-28 16:54:20.000000000 +0000
+++ b/extensions/pknock/xt_pknock.c	2021-03-07 10:10:54.375466285 +0000
@@ -247,7 +247,7 @@
 			seq_printf(s, "expir_time=%lu [secs] ", time);
 		}
 		if (peer->status == ST_ALLOWED && rule->autoclose_time != 0) {
-			unsigned long x = ktime_get_seconds();
+			unsigned long long x = ktime_get_seconds();
 			unsigned long y = peer->login_sec + rule->autoclose_time * 60;
 			time = 0;
 			if (time_before(x, y))
@@ -311,7 +311,7 @@
 static inline bool
 autoclose_time_passed(const struct peer *peer, unsigned int autoclose_time)
 {
-	unsigned long x, y;
+	unsigned long long x, y;
 	if (peer == NULL || autoclose_time == 0)
 		return false;
 	x = ktime_get_seconds();
@@ -338,7 +338,7 @@
 static inline bool
 has_logged_during_this_minute(const struct peer *peer)
 {
-	unsigned long x, y;
+	unsigned long long x, y;
 	if (peer == NULL)
 		return 0;
 	x = ktime_get_seconds();
@@ -717,7 +717,7 @@
 	unsigned int hexa_size;
 	int ret;
 	bool fret = false;
-	unsigned long x;
+	unsigned long long x;
 	unsigned int epoch_min;
 
 	if (payload_len == 0)
-------------------------

With this patch it builds but I've got warnings about pointer types

-------------------------

CC [M]  /home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/xt_iface.o
In file included from ./include/linux/irqflags.h:15,
                 from ./arch/arm/include/asm/bitops.h:28,
                 from ./include/linux/bitops.h:29,
                 from ./include/linux/kernel.h:12,
                 from ./include/linux/list.h:9,
                 from ./include/linux/module.h:12,
                 from /home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:10:
/home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c: In function 'pknock_seq_show':
./include/linux/typecheck.h:12:18: warning: comparison of distinct pointer types lacks a cast
   12 |  (void)(&__dummy == &__dummy2); \
      |                  ^~
./include/linux/jiffies.h:106:3: note: in expansion of macro 'typecheck'
  106 |   typecheck(unsigned long, b) && \
      |   ^~~~~~~~~
./include/linux/jiffies.h:108:26: note: in expansion of macro 'time_after'
  108 | #define time_before(a,b) time_after(b,a)
      |                          ^~~~~~~~~~
/home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:253:8: note: in expansion of macro 'time_before'
  253 |    if (time_before(x, y))
      |        ^~~~~~~~~~~
/home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c: In function 'autoclose_time_passed':
./include/linux/typecheck.h:12:18: warning: comparison of distinct pointer types lacks a cast
   12 |  (void)(&__dummy == &__dummy2); \
      |                  ^~
./include/linux/jiffies.h:105:3: note: in expansion of macro 'typecheck'
  105 |  (typecheck(unsigned long, a) && \
      |   ^~~~~~~~~
/home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:319:9: note: in expansion of macro 'time_after'
  319 |  return time_after(x, y);
      |         ^~~~~~~~~~
./include/linux/typecheck.h:12:18: warning: comparison of distinct pointer types lacks a cast
   12 |  (void)(&__dummy == &__dummy2); \
      |                  ^~
./include/linux/jiffies.h:106:3: note: in expansion of macro 'typecheck'
  106 |   typecheck(unsigned long, b) && \
      |   ^~~~~~~~~
/home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/pknock/xt_pknock.c:319:9: note: in expansion of macro 'time_after'
  319 |  return time_after(x, y);
      |         ^~~~~~~~~~
  CC [M]  /home/mps/aports/main/xtables-addons-lts/src/xtables-addons-3.17/extensions/xt_ipp2p.o
 
-------------------------

musl libc is 1.2.2 version and gcc is 10.2 with some patches.

TIA

