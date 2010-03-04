From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables pull request, Added --reap switch logic and man page
 update
Date: Thu, 04 Mar 2010 11:26:05 +0100
Message-ID: <4B8F8ABD.5080004@trash.net>
References: <20100303210819.30257F897F@sepang.rtg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Tim Gardner <timg@tpi.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60769 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab0CDK0I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Mar 2010 05:26:08 -0500
In-Reply-To: <20100303210819.30257F897F@sepang.rtg.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tim Gardner wrote:
> This pull request is somewhat dependent on acceptence of the patch in
> 
> http://www.spinics.net/lists/netfilter-devel/msg12072.html
> 
> After all, it doesn't make sense until the kernel has support for --reap.

The kernel patch will have to wait until the nf-next tree opens
(around -rc1), for now I'm only applying bugfixes. The iptables
patch will be merged once the kernel side is upstream (during
the next merge window). Please resubmit both at an appropriate time.
