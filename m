From: Patrick McHardy <kaber@trash.net>
Subject: Re: [oops] in text matching
Date: Fri, 30 Nov 2007 00:51:17 +0100
Message-ID: <474F5075.9060109@trash.net>
References: <1194525620.6845.5.camel@ierdnac>  <47330FE1.9020008@trash.net>	 <1194547827.3298.5.camel@ierdnac>  <4735AAC6.7040605@trash.net> <1194936719.10588.0.camel@ierdnac> <47394ABA.3070109@trash.net> <47499708.5070502@trash.net> <4749CD51.1000906@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: andrei.popa@i-neo.ro, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60235 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763546AbXK2Xvt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2007 18:51:49 -0500
In-Reply-To: <4749CD51.1000906@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira Ayuso wrote:
> Sorry for the late reply. Why should we accept zero length patterns?
> Would you consider this patch? It keeps consistent the return value of
> all textsearch approaches when a zero length pattern is passed.
>   

Applied, thanks Pablo.

