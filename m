From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: Send complete hardware header in NFLOG.
Date: Thu, 17 Jul 2008 11:14:24 +0200
Message-ID: <487F0D70.7090504@trash.net>
References: <487F0A54.5090002@trash.net> <1216285934-32268-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49906 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbYGQJO2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jul 2008 05:14:28 -0400
In-Reply-To: <1216285934-32268-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch adds some fields to NFLOG to be able to send the complete
> hardware header with all necessary informations.
> It sends to userspace:
>  * the type of hardware link
>  * the length of hardware header
>  * the hardware header
> 
> Signed-off-by: Eric Leblond <eric@inl.fr>

Thanks, added to the commit message.
