From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Don't call nf_log_packet in NFLOG module.
Date: Fri, 10 Oct 2008 14:45:16 +0200
Message-ID: <48EF4E5C.5020604@trash.net>
References: <48EE0D24.6070805@trash.net> <1223592489-9668-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53547 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724AbYJJMpT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Oct 2008 08:45:19 -0400
In-Reply-To: <1223592489-9668-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch modifies xt_NFLOG to suppress the call to nf_log_packet()
> function. The call of this wrapper in xt_NFLOG was causing NFLOG to
> use the first initialized module. Thus, if ipt_ULOG is loaded before
> nfnetlink_log all NFLOG rules are treated as plain LOG rules.

I've changed the EXPORT_SYMBOL to EXPORT_SYMBOL_GPL and applied it,
thanks.
