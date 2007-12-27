From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Quota on SMP AGAIN
Date: Thu, 27 Dec 2007 16:54:12 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712271653410.29013@fbirervta.pbzchgretzou.qr>
References: <4773C13D.1040106@simm.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: gpf <gpf@simm.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50388 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbXL0PyN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Dec 2007 10:54:13 -0500
In-Reply-To: <4773C13D.1040106@simm.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 27 2007 18:14, gpf wrote:
>
>iptables, iptables-save not working properly
>
>[root@ns bind] iptables -L quot |grep devel
>RETURN     0    --  anywhere             developer.simm.ru   quota:
>226620450 bytes
>[root@ns bind] iptables -L quot |grep devel
>RETURN     0    --  anywhere             developer.simm.ru   quota:
>226620036 bytes
>[root@ns bind] iptables -L quot |grep devel
>RETURN     0    --  anywhere             developer.simm.ru   quota:
>227219801 bytes
>[root@ns bind] iptables -L quot |grep devel
>RETURN     0    --  anywhere             developer.simm.ru   quota:
>227219801 bytes
>[root@ns bind] iptables -L quot |grep devel
>RETURN     0    --  anywhere             developer.simm.ru   quota:
>226619312 bytes
>
Well at least I can reproduce it fairly easily :-)

Linux ccgmbh 2.6.23.10-ccj62-regular #1 SMP 2007/10/26 14:17:15 UTC x86_64
x86_64 x86_64 GNU/Linux
