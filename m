From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ANNOUNCE] libmnl 1.0.0 release
Date: Tue, 21 Dec 2010 21:31:20 +0100
Message-ID: <4D110E98.5080002@netfilter.org>
References: <4D0CABC3.3090601@netfilter.org>	<alpine.LNX.2.01.1012181633390.13544@obet.zrqbmnf.qr>	<4D110BDC.4000709@netfilter.org> <20101221.122225.39203217.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: jengelh@medozas.de, lists@sterenborg.info,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44191 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab0LUUb1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Dec 2010 15:31:27 -0500
In-Reply-To: <20101221.122225.39203217.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21/12/10 21:22, David Miller wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> Date: Tue, 21 Dec 2010 21:19:40 +0100
> 
>> I think that this approach (see patch) is safe to fix this problem.
> 
> This is fine for now, but really you should have a copy of the
> headers in your tree.
> 
> It's the only way to sanely control the build in all possible
> scenerios.  The kernel headers are just too large of a variable
> for things like this.

I was thinking on the overhead that this adds since we have to keep in
sync kernel and library header files. If there's some new feature in the
kernel, you'll have to wait until the new stuff in included in the
libmnl header.

But this is indeed a problem since people will report compilation problems.

I'll make a patch to add them.
