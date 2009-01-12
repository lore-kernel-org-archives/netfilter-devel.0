From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables -git automake warnings
Date: Mon, 12 Jan 2009 07:10:38 +0100
Message-ID: <496ADEDE.9050000@trash.net>
References: <496AD8C7.2020208@trash.net> <496AD922.7050909@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56483 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbZALGKy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2009 01:10:54 -0500
Received: from [192.168.0.100] (unknown [78.42.204.165])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by stinky.trash.net (Postfix) with ESMTPSA id 041619489E
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Jan 2009 07:10:52 +0100 (MET)
In-Reply-To: <496AD922.7050909@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Patrick McHardy wrote:
>> I get this with the current iptables -git version:
>>
>> Makefile.am:7: `:='-style assignments are not portable
>> Makefile.am:71: `:='-style assignments are not portable
>> Makefile.am:72: `:='-style assignments are not portable
>> Makefile.am:73: `:='-style assignments are not portable
>> Makefile.am:74: `:='-style assignments are not portable
>> Makefile.am:75: `:='-style assignments are not portable
>> Makefile.am:78: `:='-style assignments are not portable
>> Makefile.am:80: `:='-style assignments are not portable
>> Makefile.am:97: `%'-style pattern rules are a GNU make extension
> 
> Additionally compilation aborts with:
> 
> make[2]: *** No rule to make target 
> `../include/linux/netfilter_ipv4/ipt_DSCP.h', needed by `libipt_ECN.oo'. 
>  Stop.

This is resolved by using a fresh clone.
