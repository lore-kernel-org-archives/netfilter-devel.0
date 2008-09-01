From: Patrick McHardy <kaber@trash.net>
Subject: Re: src: use regular includes
Date: Mon, 01 Sep 2008 14:20:40 +0200
Message-ID: <48BBDE18.9050105@trash.net>
References: <alpine.LNX.1.10.0808151856510.26696@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33551 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbYIAMUm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Sep 2008 08:20:42 -0400
In-Reply-To: <alpine.LNX.1.10.0808151856510.26696@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> src: use regular includes
> 
> iptables ships with all header files and prioritized its own include
> directory over /usr/include/linux, so just use the normal brackets.

Applied, thanks.
