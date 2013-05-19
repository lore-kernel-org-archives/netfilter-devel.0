From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: Query: No-flush support for ebtables-restore in v2.0.10-4
Date: Sun, 19 May 2013 21:33:51 +0200
Message-ID: <5199291F.9020009@pandora.be>
References: <51925792.3050505@elitecore.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Ankit <ankit.s.shah@elitecore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:37923 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab3ESTd7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 May 2013 15:33:59 -0400
In-Reply-To: <51925792.3050505@elitecore.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op 14/05/2013 17:26, Ankit schreef:
> Hello,
>         I am working on ebtables-v2.0.10-4 and I noticed that there is 
> no support for "no-flush" switch in ebtables-restore unlike 
> iptables-restore. Before I start digging for a roundabout solution, I 
> wanted to confirm if there is any particular reason for not 
> incorporating no-flush support in ebtables-restore? Does the netfilter 
> team have any plans to develop it further?

There's no particular reason for not supporting that. In the sunny-day 
scenario it probably suffices to call ebt_get_kernel_table() with second 
argument equal to 0 instead of 1.

Bart

