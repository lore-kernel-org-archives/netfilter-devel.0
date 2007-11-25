From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC NETFILTER 2/4]: Add xt_rateest match
Date: Sun, 25 Nov 2007 18:28:27 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711251824480.9477@fbirervta.pbzchgretzou.qr>
References: <4749ACD4.4010407@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33347 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbXKYR22 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 12:28:28 -0500
In-Reply-To: <4749ACD4.4010407@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Nov 25 2007 18:11, Patrick McHardy wrote:

>Date: Sun, 25 Nov 2007 18:11:48 +0100
>From: Patrick McHardy <kaber@trash.net>
>To: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>
>Subject: [RFC NETFILTER 2/4]: Add xt_rateest match
>
>
>index 0000000..e4e0653
>--- /dev/null
>+++ b/include/linux/netfilter/xt_rateest.h
>@@ -0,0 +1,33 @@
>+#ifndef _XT_RATEEST_MATCH_H
>+#define _XT_RATEEST_MATCH_H
>+
>+enum xt_rateest_match_flags {
>+	XT_RATEEST_MATCH_INVERT	= 0x01,
>+	XT_RATEEST_MATCH_ABS	= 0x02,
>+	XT_RATEEST_MATCH_REL	= 0x04,
>+	XT_RATEEST_MATCH_DELTA	= 0x08,
>+	XT_RATEEST_MATCH_BPS	= 0x10,
>+	XT_RATEEST_MATCH_PPS	= 0x20,
>+};

Perhaps 1<<0, 1<<1, 1<<2, ...?

>+	spin_lock_bh(&info->est1->lock);
>+	rstats	= &info->est1->rstats;
>+	if (info->flags & XT_RATEEST_MATCH_DELTA) {
>+		bps1	= info->bps1 >= rstats->bps ?
>+					info->bps1 - rstats->bps : 0;
>+		pps1	= info->pps1 >= rstats->pps ?
>+					info->pps1 - rstats->pps : 0;
>+	} else {
>+		bps1	= rstats->bps;
>+		pps1	= rstats->pps;
>+	}
>+	spin_unlock_bh(&info->est1->lock);
>+
>+	if (info->flags & XT_RATEEST_MATCH_ABS) {
>+		bps2	= info->bps2;
>+		pps2	= info->pps2;

I think you can cut down on the extra whitespace around = here,
it already lines up nicely anyway.

>+	} else {
>+		spin_lock_bh(&info->est2->lock);
>+		rstats	= &info->est2->rstats;
>+		if (info->flags & XT_RATEEST_MATCH_DELTA) {
>+			bps2	= info->bps2 >= rstats->bps ?
>+						info->bps2 - rstats->bps : 0;
>+			pps2	= info->pps2 >= rstats->pps ?
>+						info->pps2 - rstats->pps : 0;
>+		} else {
>+			bps2	= rstats->bps;
>+			pps2	= rstats->pps;
>+		}
>+		spin_unlock_bh(&info->est2->lock);
>+	}
>+
>+	switch (info->mode) {
>+	case XT_RATEEST_MATCH_LT:
>+		if (info->flags & XT_RATEEST_MATCH_BPS)
>+			ret &= bps1 < bps2;
>+		if (info->flags & XT_RATEEST_MATCH_PPS)
>+			ret &= pps1 < pps2;
>+		break;
>+	case XT_RATEEST_MATCH_GT:
>+		if (info->flags & XT_RATEEST_MATCH_BPS)
>+			ret &= bps1 > bps2;
>+		if (info->flags & XT_RATEEST_MATCH_PPS)
>+			ret &= pps1 > pps2;
>+		break;
>+	case XT_RATEEST_MATCH_EQ:
>+		if (info->flags & XT_RATEEST_MATCH_BPS)
>+			ret &= bps1 == bps2;
>+		if (info->flags & XT_RATEEST_MATCH_PPS)
>+			ret &= pps2 == pps2;
>+		break;
>+	}
>+
>+	ret ^= info->flags & XT_RATEEST_MATCH_INVERT ? true : false;
>+	return ret;
>+}

	return ret ^ !!(info->flags & XT_RATEEST_MATCH_INVERT);

