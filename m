From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Wrong MAC in redirected packet
Date: Wed, 25 Mar 2009 16:04:57 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903251603050.18819@fbirervta.pbzchgretzou.qr>
References: <17e3a8f80903250727q739fac53r6325a8eefff96a97@mail.gmail.com>  <alpine.LSU.2.00.0903251528420.19598@fbirervta.pbzchgretzou.qr> <17e3a8f80903250800q15964da1gaf24ff1670ba3802@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47169 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbZCYPFA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2009 11:05:00 -0400
In-Reply-To: <17e3a8f80903250800q15964da1gaf24ff1670ba3802@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2009-03-25 16:00, Kristian Evensen wrote:

>>>My theory is that the original MAC-address is somehow added to the SKB
>>>before it reaches the output-part of the RAW-table (which is where I
>>>hook in),
>>
>> Routing is done before rawpost, yes, but before the (traditional) raw table.
>> (it's in skb->dst)
>
>Ok, I assumed that the MAC-header was added at a lower layer, but that
>was then wrong? For some reason I have always though skb->dst was the
>IP-adress, I will look into that field.

skb->dst contains the pointer to the neighbor (simply put), and a 
neighbor is (also simplified) what you see in `ip neigh`, i.e. MAC 

>After struggling a bit with the compilation (I had to remove the
>iptable_rawpost.o ip6table_rawpost.o in Kbuild or the compiler
>complained that it couldn't find the files), I get this error when I
>try to use it:
>
>kristrev@mylatop:~/src/xtables-addons-1.12$ sudo iptables -A
>PREROUTING -t raw -p udp -d 192.168.101.14 --dport 9999 -j RAWDNAT
>--to-destination 192.168.100.250
>iptables: Invalid argument

See `dmesg` for the details of EINVAL.

