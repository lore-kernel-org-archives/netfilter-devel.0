From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/2] NFQUEUE: add new v1 version with queue-balance
 option
Date: Fri, 5 Jun 2009 15:02:23 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906051457160.17010@fbirervta.pbzchgretzou.qr>
References: <1244164679-11032-1-git-send-email-fw@strlen.de> <1244164679-11032-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fwestphal@astaro.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37026 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbZFENCV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:02:21 -0400
In-Reply-To: <1244164679-11032-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-06-05 03:17, Florian Westphal wrote:
>target4_v1{
>+	.revision	= 1,
>+	.name		= "NFQUEUE",
>+	.version	= XTABLES_VERSION,
>+	.size		= XT_ALIGN(sizeof(struct xt_NFQ_info_v1)),
>+	.userspacesize	= XT_ALIGN(sizeof(struct xt_NFQ_info_v1)),
>+	.help		= NFQUEUE_help_v1,
>+	.init		= NFQUEUE_init_v1,
>+	.parse		= NFQUEUE_parse_v1,
>+	.print		= NFQUEUE_print_v1,
>+	.save		= NFQUEUE_save_v1,
>+	.extra_opts	= NFQUEUE_opts_v1,
>+};
>+
>+static struct xtables_target nfqueue_target6_v1 = {
>+	.family		= NFPROTO_IPV6,
>+	.revision	= 1,

You can combine these two to NFPROTO_UNSPEC, like you did to v0,
is not it?

>index b2c90bb..db01021 100644
>--- a/extensions/libxt_NFQUEUE.man
>+++ b/extensions/libxt_NFQUEUE.man
>@@ -5,8 +5,18 @@ number.
> \fB\-\-queue\-num\fP \fIvalue\fP
> This specifies the QUEUE number to use. Valid queue numbers are 0 to 65535. The default value is 0.
> .PP
>+.TP
>+\fB\-\-queue\-balance\fP \fIvalue\fP:\fIvalue\fP

Minor nitpick:  "\fIvalue\fP\fB:\fP\fIvale\fP", because the : is to
be typed verbatim.

>+This specifies a range of queues to use. Packets are then balanced across the given queues.
>+This is useful for multicore systems: start multiple instances of the userspace program on
>+queues x, x+1, .. x+n and use "--queue-balance x:x+n".

\-\-queue\-balance here, too.

>+Packets belonging to the same connection are put into the same nfqueue.
>+.PP
> It can only be used with Kernel versions 2.6.14 or later, since it requires
> the
> .B
> nfnetlink_queue
> kernel support.
>+.B
>+queue-balance
>+support was added in Linux 2.6.31.

Mh, try to use \fB...\fP, as that's somehow easier to recognize given
people are familiar with HTML.

(\fBqueue-balance\fP support wa added in Linux 2.6.31.)


Looks good generally.
