From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] [connlimit] connlimit-above early loop termination
Date: Fri, 11 Feb 2011 18:00:53 +0100
Message-ID: <4D556B45.8030304@trash.net>
References: <1297441335.25407.9.camel@d941e-10>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64843 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757791Ab1BKRBO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Feb 2011 12:01:14 -0500
In-Reply-To: <1297441335.25407.9.camel@d941e-10>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11.02.2011 17:22, Stefan Berger wrote:
> The patch below introduces an early termination of the loop that is
> counting matches. It terminates once the counter has exceeded the
> threshold provided by the user. There's no point in continuing the loop
> afterwards and looking at other entries.
> 
> It plays together with the following code further below:
> 
> return (connections > info->limit) ^ info->inverse;
> 
> where connections is the result of the counted connection, which in turn
> is the matches variable in the loop. So once 
> 
>         -> matches = info->limit + 1    
> alias   -> matches > info->limit
> alias   -> matches > threshold 
> 
> we can terminate the loop.
> 

Applied, thanks Stefan.
