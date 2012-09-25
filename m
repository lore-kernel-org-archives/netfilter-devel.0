From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: have r->cost != 0 case work
Date: Tue, 25 Sep 2012 16:39:15 +0200
Message-ID: <20120925143915.GA9091@1984>
References: <alpine.LNX.2.01.1209221003280.3512@nerf07.vanv.qr>
 <1348302412-2811-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	jrobinson@infoblox.com
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40321 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501Ab2IYOj0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:39:26 -0400
Content-Disposition: inline
In-Reply-To: <1348302412-2811-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Sep 22, 2012 at 10:26:52AM +0200, Jan Engelhardt wrote:
> Commit v2.6.19-rc1~1272^2~41 tells us that r->cost != 0 can happen when
> a running state is saved to userspace and then reinstated from there.
> 
> Make sure that priv is initialized with some values when that happens.

Just to clarify: With this patch, we go back to the situation in which
the state is reset on unrelated rule updates, right?
