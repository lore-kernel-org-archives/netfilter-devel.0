From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: Modifying ebtables to read the commands from a file
Date: Sun, 28 Mar 2010 17:43:19 +0200
Message-ID: <4BAF7917.2030207@pandora.be>
References: <1269770877.2563.9.camel@qed> <alpine.LSU.2.01.1003281457380.22298@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Peter Gordon <peter@pg-consultants.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from brigitte.telenet-ops.be ([195.130.137.66]:50149 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab0C1PnX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Mar 2010 11:43:23 -0400
In-Reply-To: <alpine.LSU.2.01.1003281457380.22298@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt schreef:
> On Sunday 2010-03-28 12:07, Peter Gordon wrote:
>
>   
>> I need to add a number of rules to the ebtables and I cannot afford the
>> fork overhead for each line.
>>     
>
> The larger part of the overhead is due to the tables recomputed (dumped, 
> rule added, restored) every time you call it. That's why one should use 
> xx-restore.
>
>   
>> So what I want to do is to read each line
>>     
> >from a file and have the program iterate over the file. 
>   
>> ebtables-save and ebtables-restore is not good enough for my
>> application, because I can't add rules incrementally.
>>     
>
> Dump the rules with ebtables-save to a buffer, add your rules,
> and use -restore. That's sort of incrementally, and the fastest
> way to put a ruleset in atomic fashion into place.
>   
That's indeed the easiest way to do it. The only problem is that the
counters of already existing rules won't always be correct because
packets will traverse the chains between the -save and -restore time.
It's probably not so hard to alter ebtables-restore to keep the counters
correct.
A few years ago I experimented with an ebtables 'daemon' that would run
in the background and commands could be sent to it through a pipe. This
has the advantage that the distinction between added and already
existing rules is maintained, enabling correct counters. The changed
table is updated in userspace and only committed to the kernel when a
specific command is given. See ebtablesd.c and ebtablesu.c for the code.
Performance tests are available in examples/perf_test/perf_test. I'm not
maintaining these files for free, though.

cheers,
Bart

-- 
Bart De Schuymer
www.artinalgorithms.be

