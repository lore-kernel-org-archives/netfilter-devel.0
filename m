From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: scheduled removal of CONFIG_NF_CT_ACCT
Date: Mon, 31 May 2010 17:52:53 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1005311751330.9888@obet.zrqbmnf.qr>
References: <1275220311-12578-1-git-send-email-tobias.doerffel@gmail.com> <4C03D4BA.9070809@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Tobias Doerffel <tobias.doerffel@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Krzysztof Piotr Oledzki <ole@ans.pl>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56621 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab0EaPwy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 May 2010 11:52:54 -0400
In-Reply-To: <4C03D4BA.9070809@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-05-31 17:24, Patrick McHardy wrote:
>Tobias Doerffel wrote:
>> Removal of the CONFIG_NF_CT_ACCT was already scheduled for 2.6.29,
>> therefore remove it now and set nf_conntrack.acct depending on
>> CONFIG_NETFILTER_XT_MATCH_CONNBYTES.
>
>This has already been discussed multiple times. The connbytes
>match needs accounting, so it needs to enable it when the first
>rule containing a connbytes match is added. This needs to be
>done in the namespace where the rule is added.

If it is done as late as rule insertion, connbytes might match (or
not - and thus be a problem) when there are still CTs around without
a counter tuple. Hm.
