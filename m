From: Patrick McHardy <kaber@trash.net>
Subject: Re: CAN you give me a piece of sample code to implement this iptables
 command? thanks
Date: Sun, 11 May 2008 17:27:59 +0200
Message-ID: <4827107F.9030707@trash.net>
References: <200805112243513753221@fiberhome.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: cyx <cyx@fiberhome.com.cn>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53195 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYEKP2g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 May 2008 11:28:36 -0400
In-Reply-To: <200805112243513753221@fiberhome.com.cn>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

cyx wrote:
> HI, all:
> 
> the command is "iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE"
> 
> how to write the code using libiptc to implement this? It is hard to get enough useful information about programing with libiptc APIs, so can you give me the sample code ? thanks a lot!


libiptc doesn't provide a API for external programs, its purely
for iptables use. You *can* use it (at least some people do),
but we give no guarantees that it stays stable and additionally
it used to leak memory (not sure about the state today).
