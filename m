From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: scheduled removal of CONFIG_NF_CT_ACCT
Date: Mon, 31 May 2010 17:24:42 +0200
Message-ID: <4C03D4BA.9070809@trash.net>
References: <1275220311-12578-1-git-send-email-tobias.doerffel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Krzysztof Piotr Oledzki <ole@ans.pl>
To: Tobias Doerffel <tobias.doerffel@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59817 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394Ab0EaPYp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 May 2010 11:24:45 -0400
In-Reply-To: <1275220311-12578-1-git-send-email-tobias.doerffel@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tobias Doerffel wrote:
> Removal of the CONFIG_NF_CT_ACCT was already scheduled for 2.6.29,
> therefore remove it now and set nf_conntrack.acct depending on
> CONFIG_NETFILTER_XT_MATCH_CONNBYTES.

This has already been discussed multiple times. The connbytes
match needs accounting, so it needs to enable it when the first
rule containing a connbytes match is added. This needs to be
done in the namespace where the rule is added.
