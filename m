From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter 02/08: nf_conntrack: show helper and class in /proc/net/nf_conntrack_expect
Date: Thu, 11 Feb 2010 17:03:09 +0100
Message-ID: <4B742A3D.8070809@trash.net>
References: <20100211073932.7894.23544.sendpatchset@x2.localnet> <20100211073935.7894.11114.sendpatchset@x2.localnet> <alpine.LSU.2.01.1002111358520.30927@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44898 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab0BKQDM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 11:03:12 -0500
In-Reply-To: <alpine.LSU.2.01.1002111358520.30927@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2010-02-11 08:39, Patrick McHardy wrote:
> 
>> commit 4e4aa88c264e9f8d013e3742e48a6bea37ca1c4c
>> Author: Patrick McHardy <kaber@trash.net>
>> Date:   Thu Feb 11 07:40:30 2010 +0100
>>
>>    netfilter: nf_conntrack: show helper and class in /proc/net/nf_conntrack_expect
> 
> Were not there any plans on obsoleting these procfs files?
> 

Not from me, I often find them useful.
