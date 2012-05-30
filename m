From: miao hongbing <miao_hb@hotmail.com>
Subject: Ask an issue about how can I let netfilter-nat work normally, thanks
Date: Wed, 30 May 2012 07:51:56 +0000
Message-ID: <BAY146-W20D67378F0897FC44EC694900A0@phx.gbl>
References: <BAY146-W327D42337C6D284F3060A6900A0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bay0-omc1-s8.bay0.hotmail.com ([65.54.190.19]:60770 "EHLO
	bay0-omc1-s8.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756105Ab2E3H6H convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 May 2012 03:58:07 -0400
In-Reply-To: <BAY146-W327D42337C6D284F3060A6900A0@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



>
>
> Hi Sirs,
>
> I am Steve Miao from China, currently we use broadcom's WiFi chipset, the chipset version is 5356 the software version is linux-2.6-router-5.70.48.10.
>
> We meet an issue about fast-nat, we plan to remove fast-nat and use common netfilter-nat base some reasons, when we removed fastnat by disabling CONFIG_BCM_NAT(the option of kernle's menuconfig) or let "ipv4_conntrack_fastnat=0", fast-nat is disabled succesfully, but netfilter-NAT can not work normally, the phenomenon is: we can ping any website, can not surf it. that means ICMP can work normally but TCP/UDP can not.
>
> Could anyone pls tell me how I can let netfilter-NAT work normally? if you know it pls kindly let me know.
>
> Thank you very much!!!
>
> Regards,
> Steve 		 	   		  