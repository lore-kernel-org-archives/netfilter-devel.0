From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ctnetlink: add expectation deletion events
Date: Fri, 15 Oct 2010 18:42:38 +0200
Message-ID: <4CB8847E.4030004@netfilter.org>
References: <20101014120209.3062.89240.stgit@decadence> <4CB876D5.208@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060800030901010409010808"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54867 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932066Ab0JOQms (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Oct 2010 12:42:48 -0400
In-Reply-To: <4CB876D5.208@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060800030901010409010808
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15/10/10 17:44, Patrick McHardy wrote:
> Am 14.10.2010 14:02, schrieb Pablo Neira Ayuso:
>> This patch allows to listen to events that inform about
>> expectations destroyed.
> 
> This looks fine, but I'm wondering why we're not delivering
> events for expectations created and destroyed by helpers using
> nf_conntrack_expect_related()/nf_conntrack_unexpect_related().

We already deliver events for new expectations. Wrt. destroyed
expectations, nf_ct_unexpect_related() internally calls
nf_ct_unlink_expect(), so they are also delivered.

BTW, you can test this patch with the following patch for the
conntrack-tools (I didn't apply it yet).

--------------060800030901010409010808
Content-Type: text/x-patch;
 name="exp-destroy-ct.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="exp-destroy-ct.patch"

conntrack: allow to listen to all kind of expectation events

From: Pablo Neira Ayuso <pablo@netfilter.org>

So far, conntrack only allows to listen to events of new expectations.
With this patch, we can listen to events of destroyed expectations
(it requires Linux kernel >= 2.6.37).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c |   63 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 55 insertions(+), 8 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 51ea472..2527953 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -671,6 +671,13 @@ enum {
 	_O_ID	= (1 << 3),
 };
 
+enum {
+	CT_EVENT_F_NEW	= (1 << 0),
+	CT_EVENT_F_UPD	= (1 << 1),
+	CT_EVENT_F_DEL 	= (1 << 2),
+	CT_EVENT_F_ALL	= CT_EVENT_F_NEW | CT_EVENT_F_UPD | CT_EVENT_F_DEL,
+};
+
 static struct parse_parameter {
 	const char	*parameter[6];
 	size_t  size;
@@ -679,8 +686,7 @@ static struct parse_parameter {
 	{ {"ASSURED", "SEEN_REPLY", "UNSET", "FIXED_TIMEOUT", "EXPECTED"}, 5,
 	  { IPS_ASSURED, IPS_SEEN_REPLY, 0, IPS_FIXED_TIMEOUT, IPS_EXPECTED} },
 	{ {"ALL", "NEW", "UPDATES", "DESTROY"}, 4,
-	  {~0U, NF_NETLINK_CONNTRACK_NEW, NF_NETLINK_CONNTRACK_UPDATE, 
-	   NF_NETLINK_CONNTRACK_DESTROY} },
+	  { CT_EVENT_F_ALL, CT_EVENT_F_NEW, CT_EVENT_F_UPD, CT_EVENT_F_DEL } },
 	{ {"xml", "extended", "timestamp", "id" }, 4, 
 	  { _O_XML, _O_EXT, _O_TMS, _O_ID },
 	},
@@ -1194,6 +1200,18 @@ static int dump_exp_cb(enum nf_conntrack_msg_type type,
 	return NFCT_CB_CONTINUE;
 }
 
+static int event_exp_cb(enum nf_conntrack_msg_type type,
+			struct nf_expect *exp, void *data)
+{
+	char buf[1024];
+
+	nfexp_snprintf(buf,sizeof(buf), exp, type, NFCT_O_DEFAULT, 0);
+	printf("%s\n", buf);
+	counter++;
+
+	return NFCT_CB_CONTINUE;
+}
+
 static int count_exp_cb(enum nf_conntrack_msg_type type,
 			struct nf_expect *exp,
 			void *data)
@@ -1667,11 +1685,23 @@ int main(int argc, char *argv[])
 		break;
 		
 	case CT_EVENT:
-		if (options & CT_OPT_EVENT_MASK)
+		if (options & CT_OPT_EVENT_MASK) {
+			unsigned int nl_events = 0;
+
+			if (event_mask & CT_EVENT_F_NEW)
+				nl_events |= NF_NETLINK_CONNTRACK_NEW;
+			if (event_mask & CT_EVENT_F_UPD)
+				nl_events |= NF_NETLINK_CONNTRACK_UPDATE;
+			if (event_mask & CT_EVENT_F_DEL)
+				nl_events |= NF_NETLINK_CONNTRACK_DESTROY;
+
+			cth = nfct_open(CONNTRACK, nl_events);
+		} else {
 			cth = nfct_open(CONNTRACK,
-					event_mask & NFCT_ALL_CT_GROUPS);
-		else
-			cth = nfct_open(CONNTRACK, NFCT_ALL_CT_GROUPS);
+					NF_NETLINK_CONNTRACK_NEW |
+					NF_NETLINK_CONNTRACK_UPDATE |
+					NF_NETLINK_CONNTRACK_DESTROY);
+		}
 
 		if (!cth)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
@@ -1701,12 +1731,29 @@ int main(int argc, char *argv[])
 		break;
 
 	case EXP_EVENT:
-		cth = nfct_open(EXPECT, NF_NETLINK_CONNTRACK_EXP_NEW);
+		if (options & CT_OPT_EVENT_MASK) {
+			unsigned int nl_events = 0;
+
+			if (event_mask & CT_EVENT_F_NEW)
+				nl_events |= NF_NETLINK_CONNTRACK_EXP_NEW;
+			if (event_mask & CT_EVENT_F_UPD)
+				nl_events |= NF_NETLINK_CONNTRACK_EXP_UPDATE;
+			if (event_mask & CT_EVENT_F_DEL)
+				nl_events |= NF_NETLINK_CONNTRACK_EXP_DESTROY;
+
+			cth = nfct_open(CONNTRACK, nl_events);
+		} else {
+			cth = nfct_open(EXPECT,
+					NF_NETLINK_CONNTRACK_EXP_NEW |
+					NF_NETLINK_CONNTRACK_EXP_UPDATE |
+					NF_NETLINK_CONNTRACK_EXP_DESTROY);
+		}
+
 		if (!cth)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 		signal(SIGINT, event_sighandler);
 		signal(SIGTERM, event_sighandler);
-		nfexp_callback_register(cth, NFCT_T_ALL, dump_exp_cb, NULL);
+		nfexp_callback_register(cth, NFCT_T_ALL, event_exp_cb, NULL);
 		res = nfexp_catch(cth);
 		nfct_close(cth);
 		break;

--------------060800030901010409010808--
