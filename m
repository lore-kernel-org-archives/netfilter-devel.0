From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Don't call nf_log_packet in NFLOG module.
Date: Thu, 09 Oct 2008 15:54:44 +0200
Message-ID: <48EE0D24.6070805@trash.net>
References: <> <1223322024-20336-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51829 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbYJINyr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2008 09:54:47 -0400
In-Reply-To: <1223322024-20336-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch modifies xt_NFLOG to suppress the call to nf_log_packet()
> function. The call of this wrapper in xt_NFLOG was causing NFLOG to
> use the first initialized module. Thus, if ipt_ULOG is loaded before
> nfnetlink_log all NFLOG rules are treated as plain LOG rules.

The patch doesn't apply because of clashes with Jan's argument
encapsulation patches. Could you rediff again Dave's net-next tree
please? Thanks!

