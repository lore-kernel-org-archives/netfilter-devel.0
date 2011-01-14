From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCHv2] netfilter: audit target to record accepted/dropped
 packets
Date: Fri, 14 Jan 2011 18:29:22 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101141819300.17624@obet.zrqbmnf.qr>
References: <20110114152024.GA9654@canuck.infradead.org> <4D306FBB.8020705@trash.net> <20110114161937.GA22101@canuck.infradead.org> <20110114165937.GA5759@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	linux-audit@redhat.com, Eric Paris <eparis@parisplace.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Thomas Graf <tgraf@infradead.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55557 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab1ANR3X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jan 2011 12:29:23 -0500
In-Reply-To: <20110114165937.GA5759@canuck.infradead.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2011-01-14 17:59, Thomas Graf wrote:
>
>This patch adds a new netfilter target which creates audit records
>for packets traversing a certain chain.
>+#ifndef _XT_AUDIT_TARGET_H
>+#define _XT_AUDIT_TARGET_H
>+
>+#include <linux/types.h>
>+
>+enum {
>+	XT_AUDIT_TYPE_ACCEPT = 0,
>+	XT_AUDIT_TYPE_DROP,
>+	XT_AUDIT_TYPE_REJECT,
>+	__XT_AUDIT_TYPE_MAX,
>+};
>+
>+#define XT_AUDIT_TYPE_MAX (__XT_AUDIT_TYPE_MAX - 1)

Hm, why not just add to the enum:

enum {
	...
	__XT_AUDIT_TYPE_MAX,
	XT_AUDIT_TYPE_MAX = __XT_AUDIT_TYPE_MAX - 1,
};

>struct xt_AUDIT_info

The uppercase names are just a historical thing for module lookup,
I don't think we need screaming struct names too.

>+static void audit_proto(struct audit_buffer *ab, struct sk_buff *skb,
>+			unsigned int proto, unsigned int offset)
>+{
>+	switch (proto) {
>+	case IPPROTO_TCP:
>+	case IPPROTO_UDP:
>+	case IPPROTO_UDPLITE: {
>+		const __be16 *pptr;
>+		__be16 _ports[2];
>+
>+		pptr = skb_header_pointer(skb, offset, sizeof(_ports), _ports);
>+		if (pptr == NULL) {
>+			audit_log_format(ab, " truncated=1");
>+			return;
>+		}
>+
>+		audit_log_format(ab, " sport=%u dport=%u",
>+				 ntohs(pptr[0]), ntohs(pptr[1]));

For shorts, there is %hu available normally.

>+static int audit_tg_check(const struct xt_tgchk_param *par)
>+{
>+	const struct xt_AUDIT_info *info = par->targinfo;
>+
>+	if (info->type > XT_AUDIT_TYPE_MAX) {
>+		pr_info("Audit type out of range (valid range: 0..%u)\n",
>+			XT_AUDIT_TYPE_MAX);
>+		return -ERANGE;
>+	}
>+
>+	return 0;
>+}

Math nitpick: EDOM, not ERANGE.


Do we need __XT_AUDIT_TYPE_MAX? It is unused; that is to say,
would not this suffice:

enum {
	...,
	XT_AUDIT_TYPE_WHATEVER,
-	__XT_AUDIT_TYPE_MAX,
-	XT_AUDIT_TYPE_MAX = __XT_AUDIT_TYPE_MAX - 1,
+	XT_AUDIT_TYPE_MAX = XT_AUDIT_TYPE_WHATEVER,
};
