From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Linux 4.2 build error in net/netfilter/ipset/ip_set_hash_netnet.c
Date: Mon, 13 Jul 2015 18:41:22 +0200
Message-ID: <20150713164122.GA26283@salvia>
References: <CAHTgTXUmreHAqPfgGEd+GJNb_OEzaCuytqBTjZsE2GDqiy3TCw@mail.gmail.com>
 <20150705153520.GA23589@roeck-us.net>
 <mo0o3b$g5d$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Akemi Yagi <amyagi@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58723 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbbGMQfl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jul 2015 12:35:41 -0400
Content-Disposition: inline
In-Reply-To: <mo0o3b$g5d$1@ger.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jul 13, 2015 at 04:13:31PM +0000, Akemi Yagi wrote:
> On Sun, 05 Jul 2015 08:35:20 -0700, Guenter Roeck wrote:
> 
> > On Sat, Jul 04, 2015 at 12:44:36AM -0700, Vinson Lee wrote:
> >> Hi.
> >> 
> >> With the latest Linux 4.2-rc1, I am hitting this build error with GCC
> >> 4.4.7 on CentOS 6.
> >> 
> >>   CC      net/netfilter/ipset/ip_set_hash_netnet.o
> >> net/netfilter/ipset/ip_set_hash_netnet.c: In function
> >> ‘hash_netnet4_uadt’:
> >> net/netfilter/ipset/ip_set_hash_netnet.c:163: error: unknown field
> >> ‘cidr’ specified in initializer
> >> net/netfilter/ipset/ip_set_hash_netnet.c:163: warning: missing braces
> >> around initializer net/netfilter/ipset/ip_set_hash_netnet.c:163:
> >> warning: (near initialization for ‘e.<anonymous>.ip’)
> >> net/netfilter/ipset/ip_set_hash_netnet.c: In function
> >> ‘hash_netnet6_uadt’:
> >> net/netfilter/ipset/ip_set_hash_netnet.c:388: error: unknown field
> >> ‘cidr’ specified in initializer
> >> net/netfilter/ipset/ip_set_hash_netnet.c:388: warning: missing braces
> >> around initializer net/netfilter/ipset/ip_set_hash_netnet.c:388:
> >> warning: (near initialization for ‘e.ip[0]’)
> >> 
> > Previously fixed with commit 1a869205c75cb ("netfilter: ipset: The
> > unnamed union initialization may lead to compilation error"),
> > reintroduced with commit aff227581ed1a ("netfilter: ipset: Check CIDR
> > value only when attribute is given").
> > 
> > Guenter
> 
> I wonder what can be done to get this issue fixed. This problem was seen 
> in 4.2-rc1 and now in 4.2-rc2 on RHEL-6.6.
> 
> $ gcc --version
> gcc (GCC) 4.4.7 20120313 (Red Hat 4.4.7-11)

Could you please test this patch? Thank you.

--RnlQjJ0d97Da+TV1
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-netfilter-ipset-fix-build-error-with-old-gcc-version.patch"
Content-Transfer-Encoding: 8bit

>From 72562eafde64a242a2a1b0b40882aa7bf2b99270 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 13 Jul 2015 18:31:20 +0200
Subject: [PATCH] netfilter: ipset: fix build error with old gcc version
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

  CC      net/netfilter/ipset/ip_set_hash_netnet.o
net/netfilter/ipset/ip_set_hash_netnet.c: In function ‘hash_netnet4_uadt’: net/netfilter/ipset/ip_set_hash_netnet.c:163: error: unknown field ‘cidr’ specified in initializer

$ gcc --version
gcc (GCC) 4.4.7 20120313 (Red Hat 4.4.7-11)

Similar to 1a869205c75c ("netfilter: ipset: The unnamed union initialization
may lead to compilation error").

Reported-by: Akemi Yagi <amyagi@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_netnet.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index 3c862c0..4cafb7e 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -160,12 +160,13 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 {
 	const struct hash_netnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_netnet4_elem e = { .cidr = { HOST_MASK, HOST_MASK, }, };
+	struct hash_netnet4_elem e = {};
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 ip = 0, ip_to = 0, last;
 	u32 ip2 = 0, ip2_from = 0, ip2_to = 0, last2;
 	int ret;
 
+	e.cidr[0] = e.cidr[1] = HOST_MASK;
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
@@ -385,10 +386,11 @@ hash_netnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 		  enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_netnet6_elem e = { .cidr = { HOST_MASK, HOST_MASK, }, };
+	struct hash_netnet6_elem e = {};
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	int ret;
 
+	e.cidr[0] = e.cidr[1] = HOST_MASK;
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-- 
1.7.10.4


--RnlQjJ0d97Da+TV1--
