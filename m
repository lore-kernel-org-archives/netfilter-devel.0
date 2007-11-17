From: Patrick McHardy <kaber@trash.net>
Subject: Re: CONFIG_NETFILTER_ADVANCED
Date: Sat, 17 Nov 2007 17:14:36 +0100
Message-ID: <473F136C.80207@trash.net>
References: <20071116.044413.227110480.davem@davemloft.net>	<473D91E9.4010809@trash.net>	<20071116153541.GA25986@linuxace.com> <20071116.161926.00949588.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kernel@linuxace.com, jengelh@computergmbh.de,
	netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44254 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbXKQQPL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Nov 2007 11:15:11 -0500
In-Reply-To: <20071116.161926.00949588.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

David Miller wrote:
> From: Phil Oester <kernel@linuxace.com>
> Date: Fri, 16 Nov 2007 07:35:41 -0800
>
>   
>> I'd vote for at least FTP here...most users will use it at
>> some point (or if they don't, wonder why FTP is broken).
>>     
>
> I disagree, passive ftp is extremely pervasive, there is no reason to
> use traditional ftp these days.

I'd expect that many distribution scripts load it anyway, and IMO the
point of this config option is to support basic distribution scripts
without going through all the options manually.

There must be someone on this list not running Debian or Ubuntu :) Could
some RH/Fedora/Suse user please post the output of lsmod on his system?


