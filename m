From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf-next: TEE only
Date: Thu, 15 Apr 2010 13:56:59 +0200
Message-ID: <4BC6FF0B.4090608@trash.net>
References: <1271200907-5262-1-git-send-email-jengelh@medozas.de> <4BC59F93.8090209@trash.net> <alpine.LSU.2.01.1004141310120.13840@obet.zrqbmnf.qr> <4BC5A603.5090403@trash.net> <alpine.LSU.2.01.1004141326570.13840@obet.zrqbmnf.qr> <alpine.LSU.2.01.1004151332180.16012@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62176 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab0DOL5E (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Apr 2010 07:57:04 -0400
In-Reply-To: <alpine.LSU.2.01.1004151332180.16012@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2010-04-14 13:32, Jan Engelhardt wrote:
> I don't see why one would want the log server to be unreachable.

I don't want that, in fact I don't have use for TEE personally.

> What _does_ look reasonable however is an encapsulation device for transporting
> teed packets across multiple real hops:
> 
> 14: gre1: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1476 qdisc noqueue state UNKNOWN
>     link/gre 5.6.7.8 peer 1.2.3.4
> 
> and this case can be solved with standard(/fwmarking) policy routing
> ('default via gre1').

Sure. And it can be solved using standard routing by specifying
the oif. I'm not interested in debatting this endlessly, this is
a standard routing key and there's no reason at all to not support
it.
