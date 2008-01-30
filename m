From: Patrick McHardy <kaber@trash.net>
Subject: Re: kernel crash in nf_nat_move_storage
Date: Wed, 30 Jan 2008 17:33:32 +0100
Message-ID: <47A0A6DC.8030404@trash.net>
References: <47A062BF.1010008@redhat.com> <47A07BE3.7000600@trash.net> <47A09CC8.8060608@redhat.com> <47A0A4C6.4040705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Thomas Woerner <twoerner@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55502 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbYA3Qdv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 11:33:51 -0500
In-Reply-To: <47A0A4C6.4040705@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas Woerner wrote:
> 2.6.24 seems to be ok on i386 also, but on x86_64 it is crashing.
> 
> Thomas Woerner wrote:
>> Hello Patrick,
>>
>> after sucessfully testing 2.6.23.14-107.fc8 on my i386 test system, I 
>> installed 2.6.23.14-107.fc8 on the x86_64 system. At first I was not 
>> able to reproduce the problem, but after starting the ftp server 
>> (vsftpd) and using 'echo "quit" | telnet test-x86_64 80' several 
>> times, I got a backtrace again. Please have a look at the attachment.


Thats odd, I can't see a reason why it would crash on x86_64.
Could you add a few printks to nf_nat_move_storage to print
out the pointers?


