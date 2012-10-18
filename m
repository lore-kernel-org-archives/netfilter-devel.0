From: "Hans Schillstrom" <hans@schillstrom.com>
Subject: Re[2]:  a problem with netfilter
Date: Thu, 18 Oct 2012 08:33:18 +0200 (CEST)
Message-ID: <n3i5ua4.c8c622e631f1b5c696106a9786086596@obelix.schillstrom.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: "U.Mutlu" <for-gmane@mutluit.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-gw21.han.skanova.net ([81.236.55.21]:58455 "EHLO
	smtp-gw21.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab2JRGdY convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2012 02:33:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> Hey all,
>>
>> I am writing a linux firewall kernel module (something a bit specific)
>> using Netfilter, in C. I extract the
>> TCP header and the IP header using the functions tcp_hdr() and ip_hdr()
>> on the skb. I extract the source and
>> destination IPs without any problem, yet, when I try to see the source
>> port and the destination port i get wrong
>> values.
>>
>> sport = ntohs(tcp_hdr(skb)->source);
>> dport= ntohs(tcp_hdr(skb)->dest);
>
>Just guessing: maybe ntohs has already been applied to source and dest, so try it w/o ntohs()...

Nope,  ports or addresses is never swapped.

Your hook is to early i.e the header ptr is at the IP header 17680 is 4510h 
which is the start of an IPv4 header 
(The "transport header" is set to point at L4 much later.)

Have a look at xt_tcpudp.c and use something like this :
   th = skb_header_pointer(skb, par->thoff, sizeof(_tcph), &_tcph);

>
>> I use printk to send the info to the syslog and
>> printk(KERN_INFO "got data on port %hu from source port %hu\n", dport,
>> sport);
>>
>> the result i get is
>> "got data on port 17680 from port 84"
>> "got data on port 17680 from port 84"
>> "got data on port 17680 from port 100"
>>
>> while netstat shows me that the right values for these ports are dport =
>> 56188 and sport = 22.
>>
>> I must be doing something wrong or missing something of the bigger
>> picture, I would apreciate any insight
>> on why this behavior is generated.
>>
>> Thank you all,
>> A.
>

Regards
Hans

