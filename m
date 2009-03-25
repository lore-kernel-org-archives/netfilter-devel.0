From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: Wrong MAC in redirected packet
Date: Wed, 25 Mar 2009 16:00:32 +0100
Message-ID: <17e3a8f80903250800q15964da1gaf24ff1670ba3802@mail.gmail.com>
References: <17e3a8f80903250727q739fac53r6325a8eefff96a97@mail.gmail.com>
	 <alpine.LSU.2.00.0903251528420.19598@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:60951 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724AbZCYPAg convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2009 11:00:36 -0400
Received: by bwz17 with SMTP id 17so75965bwz.37
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Mar 2009 08:00:32 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0903251528420.19598@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>>My theory is that the original MAC-address is somehow added to the SK=
B
>>before it reaches the output-part of the RAW-table (which is where I
>>hook in),
>
> Routing is done before rawpost, yes, but before the (traditional) raw=
 table.
> (it's in skb->dst)

Ok, I assumed that the MAC-header was added at a lower layer, but that
was then wrong? For some reason I have always though skb->dst was the
IP-adress, I will look into that field.

>>because of the sender's mapping between the original
>>destination IP and MAC. However, I have not been able to figure this
>>out. Also, I =A0looked at the NAT-code, but it seems to "only" change
>>IP-address as well. Have I overlooked something or am I correct?
>
> Most likely RAWS/DNAT should gain another option to also tweak the
> MAC daddr, by calling ip_route_output_key to get a new skb->dst.

This sounds like a good idea. I will look at the ip_route_output_key,
try to write a function for my module and patch it into RAWNAT (unless
somebody else does it first).

>>Btw, RAWDNAT throws up a couple of errors on my machine, so I have no=
t
>>been able to see it it does what I want to do.
>
> Which errors?
>

After struggling a bit with the compilation (I had to remove the
iptable_rawpost.o ip6table_rawpost.o in Kbuild or the compiler
complained that it couldn't find the files), I get this error when I
try to use it:

kristrev@mylatop:~/src/xtables-addons-1.12$ sudo iptables -A
PREROUTING -t raw -p udp -d 192.168.101.14 --dport 9999 -j RAWDNAT
--to-destination 192.168.100.250
iptables: Invalid argument

-Kristian
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
