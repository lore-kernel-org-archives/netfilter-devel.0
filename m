From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] netfilter: have r->cost != 0 case work
Date: Tue, 25 Sep 2012 16:52:32 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1209251648570.12652@nerf07.vanv.qr>
References: <alpine.LNX.2.01.1209221003280.3512@nerf07.vanv.qr> <1348302412-2811-1-git-send-email-jengelh@inai.de> <20120925143915.GA9091@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	jrobinson@infoblox.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:40828 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab2IYOwf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:52:35 -0400
In-Reply-To: <20120925143915.GA9091@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2012-09-25 16:39, Pablo Neira Ayuso wrote:
>On Sat, Sep 22, 2012 at 10:26:52AM +0200, Jan Engelhardt wrote:
>> Commit v2.6.19-rc1~1272^2~41 tells us that r->cost != 0 can happen when
>> a running state is saved to userspace and then reinstated from there.
>> 
>> Make sure that priv is initialized with some values when that happens.
>
>Just to clarify: With this patch, we go back to the situation in which
>the state is reset on unrelated rule updates, right?

Before this patch, when userspace updated a rule, random things 
would happen on matching due to use of uninitialized memory.

Now, the values are initialized, and implies that the credit is reset on 
table update.
