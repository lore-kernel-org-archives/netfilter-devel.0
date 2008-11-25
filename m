From: "David Wu" <davidwu@arcturusnetworks.com>
Subject: Re: iptables (1.4.2 release) failed to run on embedded system with
 "can't initialize iptables table `filter'"
Date: Tue, 25 Nov 2008 14:07:02 -0500
Message-ID: <op.uk6vd0boqigx4y@cyprus.local>
References: <op.uky4wc2dqigx4y@cyprus.local>
 <alpine.LNX.1.10.0811211659001.12307@fbirervta.pbzchgretzou.qr>
 <op.ukze8tjtqigx4y@cyprus.local>
 <alpine.LNX.1.10.0811221204080.25317@fbirervta.pbzchgretzou.qr>
 <op.uk6pzalwqigx4y@cyprus.local>
 <alpine.LNX.1.10.0811251841070.15844@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.arcturusnetworks.com ([204.50.165.220]:33284 "EHLO
	mail.arcturusnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbYKYTHE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Nov 2008 14:07:04 -0500
In-Reply-To: <alpine.LNX.1.10.0811251841070.15844@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 25 Nov 2008 12:45:55 -0500, Jan Engelhardt <jengelh@medozas.de>  
wrote:

> On Tuesday 2008-11-25 18:10, David Wu wrote:
>>
>> It seems that I really have a 0 chains to start. Does this include  
>> default
>> chains or is it only user defined chains?
>
> Apparently only user-defined chains. Seems ok to me.

Then will there be a patch for the implementation of malloc() which  
returns a NULL for 0 size allocation?

>> I have compiled on x86(openSUSE 11.0 (X86-64)VERSION = 11.0)
>> (Linux cyprus 2.6.25.11-0.1-default #1 SMP 2008-07-13 20:48:28 +0200  
>> x86_64
>> x86_64 x86_64 GNU/Linux)
>> and enable debug() in libiptc/libiptc.c
>>
>
>



-- 
David Wu
