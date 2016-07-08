From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nft_ct: fix expiration getter
Date: Fri, 8 Jul 2016 15:25:43 +0200
Message-ID: <20160708132543.GA23868@salvia>
References: <1467809586-15950-1-git-send-email-fw@strlen.de>
 <20160708125646.GA23652@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="OgqxwSJOaUobr8KG"
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48076 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764AbcGHNZs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jul 2016 09:25:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id DE3251B694B
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jul 2016 15:25:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CD80BCA0FF
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jul 2016 15:25:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3D6B79EBA5
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jul 2016 15:25:44 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160708125646.GA23652@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 08, 2016 at 02:56:46PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jul 06, 2016 at 02:53:06PM +0200, Florian Westphal wrote:
> > We need to compute timeout.expires - jiffies, not the other way around.
> > Add a helper, another patch can then later change more places in
> > conntrack code where we currently open-code this.
> >
> > Will allow us to only change one place later when we remove per-ct timer.
> 
> Applied, thanks.

I just realized that this is broken from userspace, look:

# nft --debug=netlink add rule x y ct expiration 10s
ip x y
  [ ct load expiration => reg 1 ]
  [ cmp eq reg 1 0x0000000a ]

<cmdline>:1:1-30: Error: Could not process rule: No such file or
directory
add rule x y ct expiration 10s
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

jiffies_to_msecs() returns milliseconds, but userspace uses seconds.

--OgqxwSJOaUobr8KG
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-datatype-time_type-should-send-milliseconds-to-users.patch"

>From 899bce830f990cb32206c32f86edeb2f69ad109e Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 8 Jul 2016 15:12:31 +0200
Subject: [PATCH nft] datatype: time_type should send milliseconds to userspace

Kernel expects milliseconds, so fix this datatype to use
milliseconds instead of seconds.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/utils.h           |  1 +
 src/datatype.c            |  3 ++-
 tests/py/any/ct.t.payload | 18 +++++++++---------
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 8a1dc5e..d886764 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -83,6 +83,7 @@
 	(void) (&_max1 == &_max2);		\
 	_max1 > _max2 ? _max1 : _max2; })
 
+#define MSEC_PER_SEC	1000L
 
 /**
  * fls - find last (most-significant) bit set
diff --git a/src/datatype.c b/src/datatype.c
index 40e14c9..002c4c6 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -883,7 +883,7 @@ struct error_record *time_parse(const struct location *loc, const char *str,
 
 static void time_type_print(const struct expr *expr)
 {
-	time_print(mpz_get_uint64(expr->value));
+	time_print(mpz_get_uint64(expr->value) / MSEC_PER_SEC);
 }
 
 static struct error_record *time_type_parse(const struct expr *sym,
@@ -896,6 +896,7 @@ static struct error_record *time_type_parse(const struct expr *sym,
 	if (erec != NULL)
 		return erec;
 
+	s *= MSEC_PER_SEC;
 	if (s > UINT32_MAX)
 		return error(&sym->location, "value too large");
 
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index 7ed3338..8b1a04f 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -198,36 +198,36 @@ ip test-ip4 output
 # ct expiration 30
 ip test-ip4 output
   [ ct load expiration => reg 1 ]
-  [ cmp eq reg 1 0x0000001e ]
+  [ cmp eq reg 1 0x00007530 ]
 
 # ct expiration 22
 ip test-ip4 output
   [ ct load expiration => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
+  [ cmp eq reg 1 0x000055f0 ]
 
 # ct expiration != 233
 ip test-ip4 output
   [ ct load expiration => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
+  [ cmp neq reg 1 0x00038e28 ]
 
 # ct expiration 33-45
 ip test-ip4 output
   [ ct load expiration => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ cmp gte reg 1 0x21000000 ]
-  [ cmp lte reg 1 0x2d000000 ]
+  [ cmp gte reg 1 0xe8800000 ]
+  [ cmp lte reg 1 0xc8af0000 ]
 
 # ct expiration != 33-45
 ip test-ip4 output
   [ ct load expiration => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ cmp lt reg 1 0x21000000 ]
-  [ cmp gt reg 1 0x2d000000 ]
+  [ cmp lt reg 1 0xe8800000 ]
+  [ cmp gt reg 1 0xc8af0000 ]
 
 # ct expiration {33, 55, 67, 88}
 __set%d test-ip4 3
 __set%d test-ip4 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+	element 000080e8  : 0 [end]        element 0000d6d8  : 0 [end]    element 000105b8  : 0 [end]      element 000157c0  : 0 [end]
 ip test-ip4 output
   [ ct load expiration => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -235,7 +235,7 @@ ip test-ip4 output
 # ct expiration {33-55}
 __set%d test-ip4 7
 __set%d test-ip4 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+	element 00000000  : 1 [end]    element e8800000  : 0 [end]     element d9d60000  : 1 [end]
 ip test-ip4 output
   [ ct load expiration => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-- 
2.1.4


--OgqxwSJOaUobr8KG--
