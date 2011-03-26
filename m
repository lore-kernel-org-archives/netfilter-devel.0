From: Mark Montague <mark@catseye.org>
Subject: Re: Problem getting IPv6 port numbers
Date: Fri, 25 Mar 2011 22:54:04 -0400
Message-ID: <4D8D554C.4070907@catseye.org>
References: <4D8C7C20.8090500@catseye.org> <alpine.LNX.2.01.1103251427500.28161@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:56119 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752503Ab1CZCyH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Mar 2011 22:54:07 -0400
In-Reply-To: <alpine.LNX.2.01.1103251427500.28161@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  On March 25, 2011 9:29 , Jan Engelhardt <jengelh@medozas.de>  wrote:
>>         if (par->fragoff == 0) {
>>                 pptr = skb_header_pointer(skb, par->thoff,
>>                         sizeof(_ports), _ports);
>>                 if (pptr != NULL) {
>>                         sport = ntohs(pptr[0]);
>>                         dport = ntohs(pptr[1]);
>>                 }
>>         }
>>         /* ...remaining code omitted... */
>> }
>>
>> However, when I test this with "telnet ::1 1234", it does not work for IPv6 TCP
>> packets (I have not tried with IPv6 UDP packets yet).  By adding printk()
>> statements, I've determined that par->fragoff is never 0 for my IPv6 TCP
>> packets
> It seems that for IPv6, fragoff is only filled when you explicitly test
> for a protocol using -p.

This was the problem.  Many thanks for the answer!

Adding a "-p tcp" to my ip6tables rule causes the above code to report 
the source and destination port numbers properly.

Also of note:  it seems like the transport header can only be retrieved 
if the ip6tables rule explicitly tests for a protocol:  Without a -p 
test, I took out the "if (par->fragoff == 0)" check, with the result 
that the sport and dport were set to random (incorrect) numbers.

So I'll continue checking fragoff and I'll put in the documentation for 
the module I'm writing, "If you are using IPv6, port numbers are only 
available if you use '-p tcp' or '-p udp' in your ip6tables rule.  For 
IPv4, you do not have to use a -p test in your iptables rule; ports will 
automatically be correctly reported for protocols that use ports, and 
will be reported as 0 for protocols that do not use ports."

--
   Mark Montague
   mark@catseye.org

