From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 2/3] netfilter: add APPROVE target
Date: Fri, 21 Jan 2011 00:30:04 +0100
Message-ID: <201101210030.04459.richard@nod.at>
References: <1295563629-14996-1-git-send-email-richard@nod.at> <201101210022.36851.richard@nod.at> <alpine.LNX.2.01.1101210027070.29106@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:40874 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755815Ab1ATXaH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 18:30:07 -0500
In-Reply-To: <alpine.LNX.2.01.1101210027070.29106@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am Freitag 21 Januar 2011, 00:27:30 schrieb Jan Engelhardt:
> On Friday 2011-01-21 00:22, Richard Weinberger wrote:
> >> >+
> >> >+struct nf_approve_info {
> >> >+	u_int16_t ruleid;
> >> >+};
> >> 
> >> Intended to be "struct xt_approve_info"?
> >
> >Ok, will rename...
> 
> Oh, and as per "Writing Netfilter Modules", __u16 should be used
> in headers exported to userspace.

You mean http://jengelh.medozas.de/documents/Netfilter_Modules.pdf?

*reading*,
//richad
