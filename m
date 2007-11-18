From: David Miller <davem@davemloft.net>
Subject: Re: CONFIG_NETFILTER_ADVANCED
Date: Sun, 18 Nov 2007 13:40:14 -0800 (PST)
Message-ID: <20071118.134014.183873834.davem@davemloft.net>
References: <Pine.LNX.4.64.0711172208490.2240@fbirervta.pbzchgretzou.qr>
	<473FA140.7080708@trash.net>
	<Pine.LNX.4.64.0711181407270.17843@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43818
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754622AbXKRVkU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Nov 2007 16:40:20 -0500
In-Reply-To: <Pine.LNX.4.64.0711181407270.17843@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date: Sun, 18 Nov 2007 14:21:20 +0100 (CET)

> I think the other way around would be better:
> 
> CONFIG_NETFILTER		enable everyting
> CONFIG_NETFILTER_WITHOUT_NAT	everything except NAT
> CONFIG_NETFILTER_ADVANCED	select modules manually
> 
> This is more or less the most usual cases: typically almost everyone wants 
> NAT and the wide range of matches and targets. Some places don't use NAT. 
> And if someone wants to exclude modules or disable settings like 
> conntrack flow accounting, in advanced mode it'd be possible to do so.

This leaves no choice for the original purpose my
proposal was meant to address.

People like Linus who want one config option to choose
which gives them the basics but not "all the other random
crap" that he'll never use.
