From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables-save: output ! in position according to manpage
Date: Tue, 09 Dec 2008 15:06:56 +0100
Message-ID: <493E7B80.2060504@trash.net>
References: <alpine.LNX.1.10.0812081815510.2016@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, max@duempel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64680 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbYLIOG7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:06:59 -0500
In-Reply-To: <alpine.LNX.1.10.0812081815510.2016@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 0e874f0223d047bcb2c125a701e15b9e8af39106
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Mon Dec 8 18:16:10 2008 +0100
> 
> iptables-save: output ! in position according to manpage

Applied, thanks. Lets hope the parsing also works as specified
in the manpage :)


