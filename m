From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/3] netfilter: add APPROVE target
Date: Fri, 21 Jan 2011 00:27:30 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101210027070.29106@obet.zrqbmnf.qr>
References: <1295563629-14996-1-git-send-email-richard@nod.at> <1295563629-14996-3-git-send-email-richard@nod.at> <alpine.LNX.2.01.1101210012330.29106@obet.zrqbmnf.qr> <201101210022.36851.richard@nod.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46738 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755861Ab1ATX1b (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 18:27:31 -0500
In-Reply-To: <201101210022.36851.richard@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2011-01-21 00:22, Richard Weinberger wrote:
>> >+
>> >+struct nf_approve_info {
>> >+	u_int16_t ruleid;
>> >+};
>> 
>> Intended to be "struct xt_approve_info"?
>
>Ok, will rename...

Oh, and as per "Writing Netfilter Modules", __u16 should be used
in headers exported to userspace.

