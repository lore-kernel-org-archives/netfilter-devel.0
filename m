From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: CONFIG_COMPAT redux
Date: Tue, 02 Feb 2010 15:04:02 +0100
Message-ID: <4B6830D2.4010109@trash.net>
References: <20100201194259.GA21315@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63110 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab0BBOEI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Feb 2010 09:04:08 -0500
In-Reply-To: <20100201194259.GA21315@x200>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> Ifdef out
> 	struct nf_sockopt_ops::compat_set
> 	struct nf_sockopt_ops::compat_get
> 	struct xt_match::compat_from_user
> 	struct xt_match::compat_to_user
> 	struct xt_match::compatsize
> to make structures smaller on COMPAT=n kernels.
> 

Applied, thanks Alexey.
