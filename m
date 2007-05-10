From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables throws unknown error - suspecting 32/64 compat issue
Date: Thu, 10 May 2007 14:58:24 +0200
Message-ID: <464316F0.60709@trash.net>
References: <Pine.LNX.4.61.0705100812440.32349@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020808050106030901050700"
Cc: Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>, sparclinux@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0705100812440.32349@yvahk01.tjqt.qr>
Sender: sparclinux-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020808050106030901050700
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Jan Engelhardt wrote:
> Hi,
> 
> 
> the following command gives an error:
> 
> 	iptables -t mangle -I FORWARD -m conntrack --ctstate NEW
> 
> output is:
> 
> 	iptables: Unknown error 4294967295
> 
> As mentioned in the topic, I suspect it is due to 32-bit iptables not 
> coping correctly with the 64-bit kernel (sometimes, patches to fix these 
> are posted, so I thought it could be related). OS is Aurora Linux 2.98, 
> with their latest(?) kernel 2.6.20-1.2986.al3.3smp.


The conntrack match is missing compat support, I've queued this patch
to fix it.


--------------020808050106030901050700
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: xt_conntrack: add compat support

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ba8991494e1522be10d764b174fc4e3744c99655
tree 85d5cf3861566aa38ecb2e091be987ecfeb17655
parent 1797736897a68f556aef76a6a0963c3e8b1b4950
author Patrick McHardy <kaber@trash.net> Thu, 10 May 2007 14:57:40 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 10 May 2007 14:57:40 +0200

 net/netfilter/xt_conntrack.c |   54 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index f4ea8fe..189ded5 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -134,12 +134,66 @@ static void destroy(const struct xt_match *match, void *matchinfo)
 	nf_ct_l3proto_module_put(match->family);
 }
 
+#ifdef CONFIG_COMPAT
+struct compat_xt_conntrack_info
+{
+	compat_uint_t			statemask;
+	compat_uint_t			statusmask;
+	struct ip_conntrack_old_tuple	tuple[IP_CT_DIR_MAX];
+	struct in_addr			sipmsk[IP_CT_DIR_MAX];
+	struct in_addr			dipmsk[IP_CT_DIR_MAX];
+	compat_ulong_t			expires_min;
+	compat_ulong_t			expires_max;
+	u_int8_t			flags;
+	u_int8_t			invflags;
+};
+
+static void compat_from_user(void *dst, void *src)
+{
+	struct compat_xt_conntrack_info *cm = src;
+	struct xt_conntrack_info m = {
+		.statemask	= cm->statemask,
+		.statusmask	= cm->statusmask,
+		.expires_min	= cm->expires_min,
+		.expires_max	= cm->expires_max,
+		.flags		= cm->flags,
+		.invflags	= cm->invflags,
+	};
+	memcpy(m.tuple, cm->tuple, sizeof(m.tuple));
+	memcpy(m.sipmsk, cm->sipmsk, sizeof(m.sipmsk));
+	memcpy(m.dipmsk, cm->dipmsk, sizeof(m.dipmsk));
+	memcpy(dst, &m, sizeof(m));
+}
+
+static int compat_to_user(void __user *dst, void *src)
+{
+	struct xt_conntrack_info *m = src;
+	struct compat_xt_conntrack_info cm = {
+		.statemask	= m->statemask,
+		.statusmask	= m->statusmask,
+		.expires_min	= m->expires_min,
+		.expires_max	= m->expires_max,
+		.flags		= m->flags,
+		.invflags	= m->invflags,
+	};
+	memcpy(cm.tuple, m->tuple, sizeof(cm.tuple));
+	memcpy(cm.sipmsk, m->sipmsk, sizeof(cm.sipmsk));
+	memcpy(cm.dipmsk, m->dipmsk, sizeof(cm.dipmsk));
+	return copy_to_user(dst, &cm, sizeof(cm)) ? -EFAULT : 0;
+}
+#endif
+
 static struct xt_match conntrack_match = {
 	.name		= "conntrack",
 	.match		= match,
 	.checkentry	= checkentry,
 	.destroy	= destroy,
 	.matchsize	= sizeof(struct xt_conntrack_info),
+#ifdef CONFIG_COMPAT
+	.compatsize	= sizeof(struct compat_xt_conntrack_info),
+	.compat_from_user = compat_from_user,
+	.compat_to_user	= compat_to_user,
+#endif
 	.family		= AF_INET,
 	.me		= THIS_MODULE,
 };

--------------020808050106030901050700--
