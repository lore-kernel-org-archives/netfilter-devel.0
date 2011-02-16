From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: can libnetfilter_conntrack be used to write a userspace connection
 tracker?
Date: Wed, 16 Feb 2011 14:20:18 +0100
Message-ID: <4D5BCF12.5010001@netfilter.org>
References: <AANLkTimfmoEKVWA_kBM-1DiuTR0=OG0Y8kC5nvq0G7G-@mail.gmail.com>	<4D2E1EF6.1010003@netfilter.org> <AANLkTi=CjQZW5mOmgsk8yjk3Q10iDQp4VLYFqM43T+Ah@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090501040502020305000805"
Cc: netfilter-devel@vger.kernel.org
To: Sam Roberts <vieuxtech@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40466 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab1BPNU0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Feb 2011 08:20:26 -0500
In-Reply-To: <AANLkTi=CjQZW5mOmgsk8yjk3Q10iDQp4VLYFqM43T+Ah@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090501040502020305000805
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 16/02/11 01:08, Sam Roberts wrote:
> On Wed, Jan 12, 2011 at 1:36 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> You can implement a user-space conntrack helper with NFQUEUE and
>> libnetfilter_conntrack:
>>
>> http://people.netfilter.org/pablo/userspace-conntrack-helpers/
>>
>> You require Linux kernel >= 2.6.37
> 
> I've upgraded the kernel to
> http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.37-rc2-maverick/.
> 
> I began experiencing this bug
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=612272
> For me, conntrack -E expect is exiting immediately, on an almost unloaded box.
> 
> So I built the two conntrack projects from git master to see if that
> would help - and got a kernel bug (see other message).
> 
> Are there any other requirements? Would it be better if I build my own
> kernel? Are there any other dependency issues between the various
> players here: libnfnetlink, libnfconntrack, conntrack, and the kernel?
> 
> Or is there a limit to the users of conntrack? Can my own daemon
> (modelled on the ftp userspace example of yours), conntrack -E, and
> other users of conntrack coexist?

Probably you have hit one of the bugs that went into 2.6.37. Please, try
the patch attached. IIRC, this is fixed in -stable and 2.6.38 and later
kernels.

--------------090501040502020305000805
Content-Type: text/x-patch;
 name="0001-netfilter-fix-export-secctx-error-handling.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-netfilter-fix-export-secctx-error-handling.patch"

>From cba85b532e4aabdb97f44c18987d45141fd93faa Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 6 Jan 2011 11:25:00 -0800
Subject: [PATCH] netfilter: fix export secctx error handling

In 1ae4de0cdf855305765592647025bde55e85e451, the secctx was exported
via the /proc/net/netfilter/nf_conntrack and ctnetlink interfaces
instead of the secmark.

That patch introduced the use of security_secid_to_secctx() which may
return a non-zero value on error.

In one of my setups, I have NF_CONNTRACK_SECMARK enabled but no
security modules. Thus, security_secid_to_secctx() returns a negative
value that results in the breakage of the /proc and `conntrack -L'
outputs. To fix this, we skip the inclusion of secctx if the
aforementioned function fails.

This patch also fixes the dynamic netlink message size calculation
if security_secid_to_secctx() returns an error, since its logic is
also wrong.

This problem exists in Linux kernel >= 2.6.37.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |    2 +-
 net/netfilter/nf_conntrack_netlink.c               |   25 +++++++++++--------
 net/netfilter/nf_conntrack_standalone.c            |    2 +-
 3 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index 37f8adb..63f60fc 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -97,7 +97,7 @@ static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 
 	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
 	if (ret)
-		return ret;
+		return 0;
 
 	ret = seq_printf(s, "secctx=%s ", secctx);
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index b729ace..0cdba50 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -254,7 +254,7 @@ ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 
 	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
 	if (ret)
-		return ret;
+		return 0;
 
 	ret = -1;
 	nest_secctx = nla_nest_start(skb, CTA_SECCTX | NLA_F_NESTED);
@@ -453,16 +453,22 @@ ctnetlink_counters_size(const struct nf_conn *ct)
 	       ;
 }
 
-#ifdef CONFIG_NF_CONNTRACK_SECMARK
-static int ctnetlink_nlmsg_secctx_size(const struct nf_conn *ct)
+static inline int
+ctnetlink_secctx_size(const struct nf_conn *ct)
 {
-	int len;
+#ifdef CONFIG_NF_CONNTRACK_SECMARK
+	int len, ret;
 
-	security_secid_to_secctx(ct->secmark, NULL, &len);
+	ret = security_secid_to_secctx(ct->secmark, NULL, &len);
+	if (ret)
+		return 0;
 
-	return sizeof(char) * len;
-}
+	return nla_total_size(0) /* CTA_SECCTX */
+	       + nla_total_size(sizeof(char) * len); /* CTA_SECCTX_NAME */
+#else
+	return 0;
 #endif
+}
 
 static inline size_t
 ctnetlink_nlmsg_size(const struct nf_conn *ct)
@@ -479,10 +485,7 @@ ctnetlink_nlmsg_size(const struct nf_conn *ct)
 	       + nla_total_size(0) /* CTA_PROTOINFO */
 	       + nla_total_size(0) /* CTA_HELP */
 	       + nla_total_size(NF_CT_HELPER_NAME_LEN) /* CTA_HELP_NAME */
-#ifdef CONFIG_NF_CONNTRACK_SECMARK
-	       + nla_total_size(0) /* CTA_SECCTX */
-	       + nla_total_size(ctnetlink_nlmsg_secctx_size(ct)) /* CTA_SECCTX_NAME */
-#endif
+	       + ctnetlink_secctx_size(ct)
 #ifdef CONFIG_NF_NAT_NEEDED
 	       + 2 * nla_total_size(0) /* CTA_NAT_SEQ_ADJ_ORIG|REPL */
 	       + 6 * nla_total_size(sizeof(u_int32_t)) /* CTA_NAT_SEQ_OFFSET */
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 0fb6570..b4d7f0f 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -118,7 +118,7 @@ static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 
 	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
 	if (ret)
-		return ret;
+		return 0;
 
 	ret = seq_printf(s, "secctx=%s ", secctx);
 
-- 
1.7.2.3


--------------090501040502020305000805--
