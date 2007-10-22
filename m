From: Patrick McHardy <kaber@trash.net>
Subject: Re: QUEUE target and capabilities
Date: Mon, 22 Oct 2007 13:23:36 +0200
Message-ID: <471C8838.7050402@trash.net>
References: <9b2db90b0710210017i196253f5sedfd5348ea42a03a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Nir Tzachar <nir.tzachar@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46224 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbXJVLYS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Oct 2007 07:24:18 -0400
In-Reply-To: <9b2db90b0710210017i196253f5sedfd5348ea42a03a@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Nir Tzachar wrote:
> Hello.
> 
> I am writing an application which uses the QUEUE target, and
> encountered a simple problem. My goal is to run the application
> without root privileges. That is, start the program under root, call
> ipq_create_handle, and then drop privileges.
> 
> However, as far as I can tell, I cannot communicate with the netlink
> socket of netfilter unless the process has the CAP_NET_ADMIN
> capability (I may be wrong, but I am basing this on:
> /usr/src/linux/net/netfilter/nfnetlink.c:204:   if
> (security_netlink_recv(skb, CAP_NET_ADMIN))
> ).
> 
> So, is there a way to use the QUEUE target _after_ dropping privilages?


Apparently none besides simply keeping CAP_NET_ADMIN.
