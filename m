From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: Patch for iptables
Date: Wed, 04 Jun 2008 08:27:33 +0900 (JST)
Message-ID: <200806032327.m53NRYTk005126@toshiba.co.jp>
References: <19c1b8a90804291101x4544818agde26a61a02036c32@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: yasuyuki.kozakai@toshiba.co.jp
To: raj.khem@gmail.com, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from imx9.toshiba.co.jp ([202.33.96.51]:36437 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbYFCXdt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2008 19:33:49 -0400
Received: from imx2.toshiba.co.jp (imx2 [202.33.96.24])
	by imx9.toshiba.co.jp  with ESMTP id m53NXbhj016387
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Wed, 4 Jun 2008 08:33:37 +0900 (JST)
Received: from arc1.toshiba.co.jp ([133.199.194.235])
	by imx2.toshiba.co.jp  with ESMTP id m53NRZEn025995
	for <netfilter-devel@vger.kernel.org>; Wed, 4 Jun 2008 08:27:35 +0900 (JST)
Received: (from root@localhost)
	by arc1.toshiba.co.jp  id m53NRZZK028398
	for netfilter-devel@vger.kernel.org; Wed, 4 Jun 2008 08:27:35 +0900 (JST)
Received: from mx2.toshiba.co.jp (localhost [127.0.0.1])
	by ovp2.toshiba.co.jp  with ESMTP id m53NRZkS012298
	for <netfilter-devel@vger.kernel.org>; Wed, 4 Jun 2008 08:27:35 +0900 (JST)
In-Reply-To: <19c1b8a90804291101x4544818agde26a61a02036c32@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,

From: "Khem Raj" <raj.khem@gmail.com>
Date: Tue, 29 Apr 2008 11:01:03 -0700

> Hello Yasuyuki-san
> 
> I am not a regular contributor to iptables. However this is what I
> noticed errors when I compiled latest iptables release on glibc 2.8
> iptables is using union ip6_u directly which has been changed in
> glibc. Usually it is preferred that these unions are accessed via the
> provided macros that way any change in glibc headers is not affecting
> the package the following patch works  and I have tested it on
> OpenEmbedded.

Thank you for sending patch. I've fixed up it to apply to the recent
iptables. Please send patches to netfilter-devel@vger.kernel.org from next
time.

Patrick, please apply the following patch.

Regards,

-- Yasuyuki Kozakai

>From 8a0ecbad5da56d9bad612bc44f2d143ca498491d Mon Sep 17 00:00:00 2001
From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Date: Wed, 4 Jun 2008 08:07:05 +0900
Subject: Use s6_addr32 to access bits in int6_addr instead of incompatible name

Spotted by Khem Raj <raj.khem@gmail.com>

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 libiptc/libip6tc.c |    2 +-
 xtables.c          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libiptc/libip6tc.c b/libiptc/libip6tc.c
index effbd44..71e262e 100644
--- a/libiptc/libip6tc.c
+++ b/libiptc/libip6tc.c
@@ -113,7 +113,7 @@ typedef unsigned int socklen_t;
 #include "libiptc.c"
 
 #define BIT6(a, l) \
- ((ntohl(a->in6_u.u6_addr32[(l) / 32]) >> (31 - ((l) & 31))) & 1)
+ ((ntohl(a->s6_addr32[(l) / 32]) >> (31 - ((l) & 31))) & 1)
 
 int
 ipv6_prefix_length(const struct in6_addr *a)
diff --git a/xtables.c b/xtables.c
index 743c07b..8241687 100644
--- a/xtables.c
+++ b/xtables.c
@@ -1178,7 +1178,7 @@ void ip6parse_hostnetworkmask(const char *name, struct in6_addr **addrpp,
 	n = *naddrs;
 	for (i = 0, j = 0; i < n; ++i) {
 		for (k = 0; k < 4; ++k)
-			addrp[j].in6_u.u6_addr32[k] &= maskp->in6_u.u6_addr32[k];
+			addrp[j].s6_addr32[k] &= maskp->s6_addr32[k];
 		++j;
 		for (k = 0; k < j - 1; ++k)
 			if (IN6_ARE_ADDR_EQUAL(&addrp[k], &addrp[j - 1])) {
-- 
1.5.3.6

