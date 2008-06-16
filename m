From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrackd [ERROR] commit: Invalid argument
Date: Mon, 16 Jun 2008 02:31:07 +0200
Message-ID: <4855B44B.5030504@netfilter.org>
References: <e1aa27e00806090621r3fa83ac0s7bb89d903de3be41@mail.gmail.com> <200806111915.32313.sabelka@iue.tuwien.ac.at> <48513A30.1020908@netfilter.org> <200806130122.16216.sabelka@iue.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020101040309090205000409"
Cc: Marco Barbero <marco.barbero@gmail.com>, netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Rainer Sabelka <sabelka@iue.tuwien.ac.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from delay-am.club-internet.fr ([194.158.104.227]:55549 "EHLO
	delay-am.club-internet.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612AbYFPAvQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Jun 2008 20:51:16 -0400
In-Reply-To: <200806130122.16216.sabelka@iue.tuwien.ac.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020101040309090205000409
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Rainer Sabelka wrote:
> I tried to debug this a bit and added some printk()s in the 
> ctnetlink_create_conntrack() function to find out where the ENOMEM is coming 
> from:
> So, now I see that nf_conntrack_alloc() is not returning this error, but it is 
> coming from a couple of lines below in the same function:
> 
>         helper = nf_ct_helper_find_get(rtuple);
>         if (helper) {
>                 help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
>                 if (help == NULL) {
>                         nf_ct_helper_put(helper);
>                         err = -ENOMEM;
>                         goto err;
>                 }
> 
> There, nf_ct_helper_ext_add() returns NULL, which causes ENOMEM to be 
> returned.
> 
> I didn't debug this further because I'm rather lost in the code. But maybe 
> this gives you some hint what's wrong.

I just noticed a bug that may be the reason for EINVAL while injecting
connections that have a helper. The messages that contained connections
with helpers were malformed (one attribute was missing). Attached a
patch to fix this problem in libnetfilter_conntrack (already applied to
git, so probably it is better if you check out a working copy). With
regards to ENOMEM, probably we're hitting it because of some malformed
message.

The other patch is not directly related but it reduces the size of the
messages that are sent to kernel space to check for the existence of a
conntrack.

I have put a lot effort on the synchronization protocols in this release
but it seems that the commit still need one spin. As always, any help
testing and reporting problems is appreciated.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------020101040309090205000409
Content-Type: text/x-diff;
 name="conntrack.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="conntrack.patch"

X-Git-Url: http://git.netfilter.org/cgi-bin/gitweb.cgi?p=conntrack-tools.git;a=blobdiff_plain;f=src%2Fnetlink.c;h=387062d5f29094733bc1e19760b82a877c15182b;hp=10c464360999fe6d1b4c39f85daa6997194ff7da;hb=807f1e477baf2eb7a642e65017ede0a079ebeb4d;hpb=40598325d5ff7a6b928640e456a377001aeae285

diff --git a/src/netlink.c b/src/netlink.c
index 10c4643..387062d 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -23,6 +23,7 @@
 #include "log.h"
 #include "debug.h"
 
+#include <string.h>
 #include <errno.h>
 
 int ignore_conntrack(struct nf_conntrack *ct)
@@ -219,8 +220,15 @@ int nl_overrun_request_resync(void)
 int nl_exist_conntrack(struct nf_conntrack *ct)
 {
 	int ret;
+	char __tmp[nfct_maxsize()];
+	struct nf_conntrack *tmp = (struct nf_conntrack *) (void *)__tmp;
 
-	ret = nfct_query(STATE(dump), NFCT_Q_GET, ct);
+	memset(__tmp, 0, sizeof(__tmp));
+
+	/* use the original tuple to check if it is there */
+	nfct_copy(tmp, ct, NFCT_CP_ORIG);
+
+	ret = nfct_query(STATE(dump), NFCT_Q_GET, tmp);
 	if (ret == -1)
 		return errno == ENOENT ? 0 : -1;
 

--------------020101040309090205000409
Content-Type: text/x-diff;
 name="libnetfilter_conntrack.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libnetfilter_conntrack.patch"

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sun, 15 Jun 2008 23:58:41 +0000 (+0200)
Subject: fix wrong ATTR_*_L3PROTO handling in the message building
X-Git-Url: http://git.netfilter.org/cgi-bin/gitweb.cgi?p=libnetfilter_conntrack.git;a=commitdiff_plain;h=29ce47fc611015a64f66d1ec93c67a9d998f0592;hp=0ceaca69ad2517e156066203111e153084140a18

fix wrong ATTR_*_L3PROTO handling in the message building

- include missing ATTR_MASTER_L3PROTO attribute into messages
- include ATTR_[ORIG|REPL]_L3PROTO iff there is at least another layer 3
attribute
---

diff --git a/src/conntrack/parse.c b/src/conntrack/parse.c
index a18e3ad..7b6c0c5 100644
--- a/src/conntrack/parse.c
+++ b/src/conntrack/parse.c
@@ -379,23 +379,29 @@ void __parse_conntrack(const struct nlmsghdr *nlh,
 {
 	struct nfgenmsg *nfhdr = NLMSG_DATA(nlh);
 
-	ct->tuple[__DIR_ORIG].l3protonum = nfhdr->nfgen_family;
-	set_bit(ATTR_ORIG_L3PROTO, ct->set);
+	if (cda[CTA_TUPLE_ORIG-1]) {
+		ct->tuple[__DIR_ORIG].l3protonum = nfhdr->nfgen_family;
+		set_bit(ATTR_ORIG_L3PROTO, ct->set);
 
-	ct->tuple[__DIR_REPL].l3protonum = nfhdr->nfgen_family;
-	set_bit(ATTR_REPL_L3PROTO, ct->set);
-
-	if (cda[CTA_TUPLE_ORIG-1])
 		__parse_tuple(cda[CTA_TUPLE_ORIG-1], 
 			      &ct->tuple[__DIR_ORIG], __DIR_ORIG, ct->set);
+	}
+
+	if (cda[CTA_TUPLE_REPLY-1]) {
+		ct->tuple[__DIR_REPL].l3protonum = nfhdr->nfgen_family;
+		set_bit(ATTR_REPL_L3PROTO, ct->set);
 
-	if (cda[CTA_TUPLE_REPLY-1])
 		__parse_tuple(cda[CTA_TUPLE_REPLY-1], 
 			      &ct->tuple[__DIR_REPL], __DIR_REPL, ct->set);
+	}
+
+	if (cda[CTA_TUPLE_MASTER-1]) {
+		ct->tuple[__DIR_MASTER].l3protonum = nfhdr->nfgen_family;
+		set_bit(ATTR_MASTER_L3PROTO, ct->set);
 
-	if (cda[CTA_TUPLE_MASTER-1])
 		__parse_tuple(cda[CTA_TUPLE_MASTER-1], 
 			      &ct->tuple[__DIR_MASTER], __DIR_MASTER, ct->set);
+	}
 
 	if (cda[CTA_NAT_SEQ_ADJ_ORIG-1])
 		__parse_nat_seq(cda[CTA_NAT_SEQ_ADJ_ORIG-1], ct, __DIR_ORIG);

--------------020101040309090205000409--
