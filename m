From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 7/7] netfilter: fix nflog timeout handling.
Date: Wed, 11 Feb 2009 15:33:45 +0100
Message-ID: <4992E1C9.2090504@trash.net>
References: <49909B3E.0@inl.fr> <1234213876-8176-7-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51804 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZBKOdt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:33:49 -0500
In-Reply-To: <1234213876-8176-7-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> NFLOG timeout was computed in timer by doing:
>  flushtimeout*HZ/100
> Default value of flushtimeout was HZ (for 1 second delay). This was
> wrong for non 100HZ computer. This patch modify the default delay by
> using 100 instead of HZ.

Applied, thanks.
