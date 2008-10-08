From: Patrick McHardy <kaber@trash.net>
Subject: Re: [iptables PATCH 2/2] [TPROXY] Add userspace component of the
 socket match
Date: Wed, 08 Oct 2008 14:33:56 +0200
Message-ID: <48ECA8B4.40407@trash.net>
References: <20081008071541.9224.66180.stgit@nessa.odu> <20081008071541.9224.68351.stgit@nessa.odu> <alpine.LNX.1.10.0810080803330.27120@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: KOVACS Krisztian <hidden@sch.bme.hu>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48863 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbYJHMd6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 08:33:58 -0400
In-Reply-To: <alpine.LNX.1.10.0810080803330.27120@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2008-10-08 03:15, KOVACS Krisztian wrote:
>> @@ -0,0 +1,39 @@
>> +/*
>> + * Shared library add-on to iptables to add early socket matching support.
>> + *
>> + * Copyright (C) 2007 BalaBit IT Ltd.
>> + */
>> + [...]
> 
> I doubt this trivial code is anything you could copyright.

It doesn't hurt to claim copyright though. No need to change this.
