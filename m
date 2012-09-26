From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] netfilter: have r->cost != 0 case work
Date: Wed, 26 Sep 2012 15:28:27 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1209261526520.6984@nerf07.vanv.qr>
References: <alpine.LNX.2.01.1209221003280.3512@nerf07.vanv.qr> <1348302412-2811-1-git-send-email-jengelh@inai.de> <20120925143915.GA9091@1984> <alpine.LNX.2.01.1209251648570.12652@nerf07.vanv.qr> <20120925232739.GB12349@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	jrobinson@infoblox.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:47857 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756043Ab2IZN22 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Sep 2012 09:28:28 -0400
In-Reply-To: <20120925232739.GB12349@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2012-09-26 01:27, Pablo Neira Ayuso wrote:
>
>> Now, the values are initialized, and implies that the credit is reset on 
>> table update.
>
>This is what I wanted to confirm. Thanks Jan.
>
>I'll pass this to David. Let's see if we can get this into 3.6-rc.

This would even be -stable material.
