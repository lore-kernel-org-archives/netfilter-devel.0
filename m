From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nfnetlink_log: fix silly refcount leak
Date: Fri, 26 Feb 2010 17:49:11 +0100
Message-ID: <4B87FB87.1090004@trash.net>
References: <20100224191847.GA3390@core2>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59592 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965360Ab0BZQtN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Feb 2010 11:49:13 -0500
In-Reply-To: <20100224191847.GA3390@core2>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> Quick fix for memory/module refcount leak.
> Reference count of listener instance never reaches 0.
> 
> Start/stop of ulogd2 is enough to trigger this bug!
> 
> Now, refcounting there looks very fishy in particular this code:
> 
>  	if (!try_module_get(THIS_MODULE)) {
> 		...
> 
> and creation of listener instance with refcount 2,
> so it may very well be ripped and redone. :-)

Applied, thanks Alexey.
