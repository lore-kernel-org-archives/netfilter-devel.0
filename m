From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: new target - ebtables dynamic snat, kernel and userspace patch
Date: Thu, 24 Sep 2009 22:24:17 +0200
Message-ID: <4ABBD571.7050206@pandora.be>
References: <4ABB2336.6040806@storwize.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, shai.tahar@storwize.com
To: Shai Tahar <shait@storwize.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:41811 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbZIXUYQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Sep 2009 16:24:16 -0400
In-Reply-To: <4ABB2336.6040806@storwize.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Shai Tahar schreef:
> ---- README ---
> ebt_dyn_snat - ebtable dynamic snat
>     Authors:
>       Shai Tahar <shai.tahar@storwize.com>
>
>     Changes source mac address according to source ip address based on 
> local arp table
>     to be used when source ip address is snated
>
Hi,

A few comments/questions.
Why is the standard target DROP?
Please provide a man file entry (ebtables.8)
You didn't provide the configuration option for the kernel
Please provide the patches as attachments (separate files for kernel and 
userspace) that will patch correctly with 'patch -p1 < $file'
After a first glance the code looks ok.
Maybe the description of your target should be more general: it matches 
the ARP source address to the IP source address based on the local arp 
table. Your target is indeed useful to make a bridging firewall that 
does IP NAT more transparent.

cheers,
Bart

