From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Patch net-next] netfilter: remove xt_NOTRACK
Date: Mon, 3 Sep 2012 21:24:55 +0200
Message-ID: <20120903192455.GA3527@1984>
References: <1345962219-2999-1-git-send-email-amwang@redhat.com>
 <CAHo-Ooz0SDBZTvBKRR-bZs0wHk25bSLaYgUYF0njUgxY8iGWpA@mail.gmail.com>
 <alpine.LNX.2.01.1208262201520.32152@frira.zrqbmnf.qr>
 <CAM_iQpU2GPgHP1BVfL_JL6dadjHeiU08en+UpAicjmH3H0QX5Q@mail.gmail.com>
 <20120903153121.GA19926@1984>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="fdj2RfSjLxBAspz7"
Content-Transfer-Encoding: 8bit
Cc: Jan Engelhardt <jengelh@inai.de>,
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	Cong Wang <amwang@redhat.com>, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>, netfilter@vger.kernel.org
To: Cong Wang <xiyou.wangcong@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39749 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756345Ab2ICTY7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Sep 2012 15:24:59 -0400
Content-Disposition: inline
In-Reply-To: <20120903153121.GA19926@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Sep 03, 2012 at 05:31:21PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 03, 2012 at 03:57:53PM +0800, Cong Wang wrote:
> > On Mon, Aug 27, 2012 at 4:04 AM, Jan Engelhardt <jengelh@inai.de> wrote:
> > > On Sunday 2012-08-26 12:42, Maciej Żenczykowski wrote:
> > >
> > >>Sounds like the old -t raw ... -j NOTRACK is replaced by -t raw ... -j
> > >>CT --notrack.
> > >>Will -j NOTRACK continue to work?  Could it be added as an alias to CT?
> > >
> > > No, and, dunno. There are currently no provisions for aliasing in the
> > > userspace side.
> > 
> > So no objections from you, right? :)
> 
> Applied, thanks.
> 
> I think it can be possible to rewrite the iptables NOTRACK user-space
> extension to use the CT target. Still I would need to check if some
> more sophisticated aliasing can be possible.
> 
> And iptables-save will show the CT target though, but that shouldn't
> be a problem.

I've made the following patch. It adds some simple aliasing to
iptables. Now NOTRACK uses the CT target, it also spots a warning
telling that it's been deprecated.

--fdj2RfSjLxBAspz7
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="alias.patch"

diff --git a/extensions/libxt_NOTRACK.c b/extensions/libxt_NOTRACK.c
index ca58700..a6b66af 100644
--- a/extensions/libxt_NOTRACK.c
+++ b/extensions/libxt_NOTRACK.c
@@ -1,15 +1,78 @@
-/* Shared library add-on to iptables to add NOTRACK target support. */
+/*
+ * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/*
+ * Shared library add-on to iptables to add NOTRACK target support: This
+ * is an alias of the CT target, since it has been deprecated.
+ */
+
+#include <stdio.h>
 #include <xtables.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <linux/netfilter/xt_CT.h>
+
+static void ct_tg_init_v0(struct xt_entry_target *target)
+{
+	struct xt_ct_target_info *info = (void *)target->data;
+
+	fprintf(stderr, "warning: NOTRACK target is deprecated, "
+			"use CT target instead\n");
+	info->flags |= XT_CT_NOTRACK;
+}
+
+static void ct_tg_init_v1(struct xt_entry_target *target)
+{
+	struct xt_ct_target_info_v1 *info = (void *)target->data;
+
+	fprintf(stderr, "warning: NOTRACK target is deprecated, "
+			"use CT target instead\n");
+	info->flags |= XT_CT_NOTRACK;
+}
+
+static void
+ct_tg_print(const void *ip, const struct xt_entry_target *target, int numeric)
+{
+	printf(" CT notrack");
+}
+
+static void ct_tg_save(const void *ip, const struct xt_entry_target *target)
+{
+	printf(" --notrack");
+}
 
-static struct xtables_target notrack_target = {
-	.family		= NFPROTO_UNSPEC,
-	.name		= "NOTRACK",
-	.version	= XTABLES_VERSION,
-	.size		= XT_ALIGN(0),
-	.userspacesize	= XT_ALIGN(0),
+static struct xtables_target ct_tg_target_reg[] = {
+	{
+		.family		= NFPROTO_UNSPEC,
+		.name		= "NOTRACK",
+		.alias		= "CT",
+		.revision	= 0,
+		.version	= XTABLES_VERSION,
+		.size		= XT_ALIGN(sizeof(struct xt_ct_target_info)),
+		.userspacesize	= offsetof(struct xt_ct_target_info, ct),
+		.print		= ct_tg_print,
+		.save		= ct_tg_save,
+		.init		= ct_tg_init_v0,
+	},
+	{
+		.family		= NFPROTO_UNSPEC,
+		.name		= "NOTRACK",
+		.alias		= "CT",
+		.revision	= 1,
+		.version	= XTABLES_VERSION,
+		.size		= XT_ALIGN(sizeof(struct xt_ct_target_info_v1)),
+		.userspacesize	= offsetof(struct xt_ct_target_info_v1, ct),
+		.print		= ct_tg_print,
+		.save		= ct_tg_save,
+		.init		= ct_tg_init_v1,
+	},
 };
 
 void _init(void)
 {
-	xtables_register_target(&notrack_target);
+	xtables_register_targets(ct_tg_target_reg, ARRAY_SIZE(ct_tg_target_reg));
 }
diff --git a/include/xtables.h.in b/include/xtables.h.in
index db69c03..99a71a7 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -280,9 +280,11 @@ struct xtables_target
 
 	struct xtables_target *next;
 
-
 	const char *name;
 
+	/* Real target behind this, if any. */
+	const char *alias;
+
 	/* Revision of target (0 by default). */
 	u_int8_t revision;
 
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index b191d5d..cc708cd 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1286,7 +1286,11 @@ static void command_jump(struct iptables_command_state *cs)
 
 	cs->target->t = xtables_calloc(1, size);
 	cs->target->t->u.target_size = size;
-	strcpy(cs->target->t->u.user.name, cs->jumpto);
+	if (cs->target->alias == NULL)
+		strcpy(cs->target->t->u.user.name, cs->jumpto);
+	else
+		strcpy(cs->target->t->u.user.name, cs->target->alias);
+
 	cs->target->t->u.user.revision = cs->target->revision;
 	xs_init_target(cs->target);
 	if (cs->target->x6_options != NULL)
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 03ac63b..eb58b8c 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -1295,7 +1295,11 @@ static void command_jump(struct iptables_command_state *cs)
 
 	cs->target->t = xtables_calloc(1, size);
 	cs->target->t->u.target_size = size;
-	strcpy(cs->target->t->u.user.name, cs->jumpto);
+	if (cs->target->alias == NULL)
+		strcpy(cs->target->t->u.user.name, cs->jumpto);
+	else
+		strcpy(cs->target->t->u.user.name, cs->target->alias);
+
 	cs->target->t->u.user.revision = cs->target->revision;
 	xs_init_target(cs->target);
 

--fdj2RfSjLxBAspz7--
