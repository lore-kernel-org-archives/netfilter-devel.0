From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/4] netfilter: ctnetlink: allow to specify the expectation
 flags
Date: Wed, 22 Sep 2010 00:38:30 +0200
Message-ID: <4C9933E6.2000500@netfilter.org>
References: <20100921092843.3279.6914.stgit@decadence> <20100921093508.3279.65795.stgit@decadence> <4C98CCD4.2050801@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020801000200060208090406"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41689 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab0IUWik (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Sep 2010 18:38:40 -0400
In-Reply-To: <4C98CCD4.2050801@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020801000200060208090406
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21/09/10 17:18, Patrick McHardy wrote:
> Am 21.09.2010 11:35, schrieb Pablo Neira Ayuso:
>> With this patch, you can specify the expectation flags for user-space
>> created expectations.
> 
> We don't seem to be dumping the flags to userspace. I think this
> should be added for consistency.

I have included this in a new version of the patch, find it attached.

--------------020801000200060208090406
Content-Type: text/x-patch;
 name="exp-flags.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="exp-flags.patch"

netfilter: ctnetlink: allow to specify the expectation flags

With this patch, you can specify the expectation flags for user-space
created expectations.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_common.h |    4 ++++
 include/linux/netfilter/nfnetlink_conntrack.h |    1 +
 include/net/netfilter/nf_conntrack_expect.h   |    3 ---
 net/netfilter/nf_conntrack_netlink.c          |    8 +++++++-
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 1afd18c..fdc50ca 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -100,6 +100,10 @@ enum ip_conntrack_expect_events {
 	IPEXP_NEW,		/* new expectation */
 };
 
+/* expectation flags */
+#define NF_CT_EXPECT_PERMANENT		0x1
+#define NF_CT_EXPECT_INACTIVE		0x2
+
 #ifdef __KERNEL__
 struct ip_conntrack_stat {
 	unsigned int searched;
diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/netfilter/nfnetlink_conntrack.h
index 9ed534c..455f0ce 100644
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -161,6 +161,7 @@ enum ctattr_expect {
 	CTA_EXPECT_ID,
 	CTA_EXPECT_HELP_NAME,
 	CTA_EXPECT_ZONE,
+	CTA_EXPECT_FLAGS,
 	__CTA_EXPECT_MAX
 };
 #define CTA_EXPECT_MAX (__CTA_EXPECT_MAX - 1)
diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 11e8150..96bb42a 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -67,9 +67,6 @@ struct nf_conntrack_expect_policy {
 
 #define NF_CT_EXPECT_CLASS_DEFAULT	0
 
-#define NF_CT_EXPECT_PERMANENT	0x1
-#define NF_CT_EXPECT_INACTIVE	0x2
-
 int nf_conntrack_expect_init(struct net *net);
 void nf_conntrack_expect_fini(struct net *net);
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 37533a3..0804e0e 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1577,6 +1577,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 
 	NLA_PUT_BE32(skb, CTA_EXPECT_TIMEOUT, htonl(timeout));
 	NLA_PUT_BE32(skb, CTA_EXPECT_ID, htonl((unsigned long)exp));
+	NLA_PUT_BE32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags));
 	helper = rcu_dereference(nfct_help(master)->helper);
 	if (helper)
 		NLA_PUT_STRING(skb, CTA_EXPECT_HELP_NAME, helper->name);
@@ -1734,6 +1735,7 @@ static const struct nla_policy exp_nla_policy[CTA_EXPECT_MAX+1] = {
 	[CTA_EXPECT_ID]		= { .type = NLA_U32 },
 	[CTA_EXPECT_HELP_NAME]	= { .type = NLA_NUL_STRING },
 	[CTA_EXPECT_ZONE]	= { .type = NLA_U16 },
+	[CTA_EXPECT_FLAGS]	= { .type = NLA_U32 },
 };
 
 static int
@@ -1933,9 +1935,13 @@ ctnetlink_create_expect(struct net *net, u16 zone,
 		goto out;
 	}
 
+	if (cda[CTA_EXPECT_FLAGS])
+		exp->flags = ntohl(nla_get_be32(cda[CTA_EXPECT_FLAGS]));
+	else
+		exp->flags = 0;
+
 	exp->class = 0;
 	exp->expectfn = NULL;
-	exp->flags = 0;
 	exp->master = ct;
 	exp->helper = NULL;
 	memcpy(&exp->tuple, &tuple, sizeof(struct nf_conntrack_tuple));

--------------020801000200060208090406--
