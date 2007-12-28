From: Patrick McHardy <kaber@trash.net>
Subject: Re: Quota on SMP AGAIN
Date: Fri, 28 Dec 2007 16:26:51 +0100
Message-ID: <477515BB.1060303@trash.net>
References: <4773C13D.1040106@simm.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: gpf <gpf@simm.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32773 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbXL1P1F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Dec 2007 10:27:05 -0500
In-Reply-To: <4773C13D.1040106@simm.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

gpf wrote:
> hi
>
> iptables, iptables-save not working properly
>
> [root@ns bind] iptables -L quot |grep devel
> RETURN     0    --  anywhere             developer.simm.ru   quota:
> 226620450 bytes
> [root@ns bind] dpkg -l |grep iptables
> ii  iptables                   1.3.6.0debian1-5
>   


The quota extension in old iptables releases is incompatible with the
version merged upstream.
