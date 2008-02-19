From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 2/3] xt_hashlimit: remove unneeded struct member
Date: Tue, 19 Feb 2008 13:51:05 +0100
Message-ID: <47BAD0B9.7090104@trash.net>
References: <Pine.LNX.4.64.0802061453480.23855@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0802061456590.23855@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep20-int.chello.at ([62.179.121.40]:48713 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbYBSMvU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 07:51:20 -0500
In-Reply-To: <Pine.LNX.4.64.0802061456590.23855@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 37d4e7f3a3f55274315c8a64bf9c005a0201ce3c
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Tue Jan 29 16:30:58 2008 +0100
> 
>     [NETFILTER]: xt_hashlimit: remove unneeded struct member
>     
>     By allocating ->hinfo, we already have the needed indirection to cope
>     with the per-cpu xtables struct match_entry.


Applied, thanks.
