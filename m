From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] netfilter: if set per-rule qthreshold overrides per-instance
Date: Mon, 09 Feb 2009 18:33:10 +0100
Message-ID: <499068D6.1050502@trash.net>
References: <1233354708-22009-1-git-send-email-eric@inl.fr> <1233354708-22009-2-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60141 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbZBIRdN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:33:13 -0500
In-Reply-To: <1233354708-22009-2-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> In NFLOG the per-rule qthreshold should overrides per-instance only
> it is set. With current code, the per-rule qthreshold is 1 if not set
> and it overrides the per-instance qthreshold.
> 
> This patch modifies the default xt_NFLOG threshold from 1 to
> 0. Thus a value of 0 means there is no per-rule setting and the instance
> parameter has to apply.

This makes much more sense :) Applied, thanks.
