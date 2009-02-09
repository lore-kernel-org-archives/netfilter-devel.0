From: Patrick McHardy <kaber@trash.net>
Subject: Re: libxtables rework
Date: Mon, 09 Feb 2009 18:50:44 +0100
Message-ID: <49906CF4.2080201@trash.net>
References: <1234200900-5964-1-git-send-email-jengelh@medozas.de> <49906A64.80502@trash.net> <alpine.LSU.2.00.0902091844020.7954@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60495 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425AbZBIRur (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:50:47 -0500
In-Reply-To: <alpine.LSU.2.00.0902091844020.7954@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2009-02-09 18:39, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> Patrick McHardy wrote on  2009-02-09 15:39:16:
>>>
>>>> So I prefer a resubmission in any case.
>>> Jan Engelhardt (16):
>>>      src: remove redundant returns at end of void-returning functions
>>>      src: remove redundant casts
>>>      libxt_owner: use correct UID/GID boundaries
>>>      extensions: use UINT_MAX constants over open-coded bits (1/2)
>>>      extensions: use UINT_MAX constants over open-coded numbers (2/2)
>>>      libxtables: prefix/order - libdir
>>>      libxtables: prefix/order - strtoui
>>>      libxtables: prefix/order - program_name
>>>      libxtables: prefix/order - param_act
>>>      libxtables: prefix/order - ipaddr/ipmask to ascii output
>>>      libxtables: prefix/order - ascii to ipaddr/ipmask input
>>>      libxtables: prefix - misc functions
>>>      libxtables: prefix - parse and escaped output func
>>>      libxtables: prefix/order - move check_inverse to xtables.c
>>>      libxtables: prefix/order - move parse_protocol to xtables.c
>>>      libxtables: move afinfo around
>> Thanks. Is there also a git tree to pull from? :)
>>
> lol - I hate you :)  Or Pablo, depending on who requested patches
> instead of wanting to pull.
> 
> But be my guest anytime -
> 	git://dev.medozas.de/iptables master

With this amount of patches, I prefer both actually, patches for
review and a tree for pulling :)

Thanks.

