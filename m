From: Thomas Woerner <twoerner@redhat.com>
Subject: Re: kernel crash in nf_nat_move_storage
Date: Wed, 30 Jan 2008 17:24:38 +0100
Message-ID: <47A0A4C6.4040705@redhat.com>
References: <47A062BF.1010008@redhat.com> <47A07BE3.7000600@trash.net> <47A09CC8.8060608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761052AbYA3QYm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 11:24:42 -0500
In-Reply-To: <47A09CC8.8060608@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2.6.24 seems to be ok on i386 also, but on x86_64 it is crashing.

Thomas Woerner wrote:
> Hello Patrick,
> 
> after sucessfully testing 2.6.23.14-107.fc8 on my i386 test system, I 
> installed 2.6.23.14-107.fc8 on the x86_64 system. At first I was not 
> able to reproduce the problem, but after starting the ftp server 
> (vsftpd) and using 'echo "quit" | telnet test-x86_64 80' several times, 
> I got a backtrace again. Please have a look at the attachment.
> 
> Thanks,
> Thomas
> 
> Patrick McHardy wrote:
>> Thomas Woerner wrote:
>>> Hello,
>>>
>>> Using port forwarding from port 80 to 21 with nf_conntrack_ftp loaded 
>>> results in a kernel crash, when connecting to port 80 from a remote
>>> host. This seems to be a problem for kernels > 2.6.18 including 2.6.24.
>>>
>>> Steps to Reproduce:
>>>
>>> host1> iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j 
>>> DNAT --to :21
>>> host1> iptables -t filter -A INPUT -i eth0 -m state --state NEW -m 
>>> tcp -p tcp --dport 21 -j ACCEPT
>>> host1> modprobe ip_conntrack_ftp
>>> host2> telnet host1 80
>>>
>>> Attached is the kernel crash log for kernel 2.6.23.9-85.fc8PAE. I was 
>>> told that this kernel crash dump is incomplete, but it took several 
>>> attempts to get a log with more that 5 lines over serial console. The 
>>> kernel seems to die too fast.
>>
>>
>> This is already fixed in 2.6.23.10.
>> -
>> To unsubscribe from this list: send the line "unsubscribe 
>> netfilter-devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


-- 
Thomas Woerner
Software Engineer            Phone: +49-711-96437-310
Red Hat GmbH                 Fax  : +49-711-96437-111
Hauptstaetterstr. 58         Email: Thomas Woerner <twoerner@redhat.com>
D-70178 Stuttgart            Web  : http://www.redhat.de/
