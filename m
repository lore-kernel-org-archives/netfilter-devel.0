From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ULOGD PATCH] Fix crash when using NFCT with hash_enable=0.
Date: Wed, 04 Jun 2008 15:19:41 +0200
Message-ID: <4846966D.4050808@trash.net>
References: <> <1212568694-3980-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@nefilter.org, netfilter-devel@vger.kernel.org,
	regit <regit@ghlodit.inl.fr>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40927 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbYFDNTn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:19:43 -0400
In-Reply-To: <1212568694-3980-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> From: regit <regit@ghlodit.inl.fr>
> 
> This patch fixes NFCT when hash_enable is 0. Limitation of treatment to NFCT_DESTROY
> message type causes usage of the hashtable function and hence a crash because it is
> not initiated.
> 
> Signed-off-by: regit <regit@ghlodit.inl.fr>

Applied, thanks.
