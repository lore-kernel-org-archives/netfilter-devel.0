From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfiler: compat out of scope fix
Date: Mon, 08 Feb 2010 15:45:31 +0100
Message-ID: <4B70238B.3050102@trash.net>
References: <20100205221757.GD27953@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, viro@zeniv.linux.org.uk
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36138 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab0BHOpe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Feb 2010 09:45:34 -0500
In-Reply-To: <20100205221757.GD27953@x200>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> As per 6.2.4(2) when temporary table data goes out of scope,
> the behaviour is undefined:
> 
> 	if (compat) {
> 		struct foo tmp;
> 		...
> 		private = &tmp;
> 	}
> 	[dereference private]

I fixed the changelog to explicitly refer to C99 and applied
your patch, thanks.
