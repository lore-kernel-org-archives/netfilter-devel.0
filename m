From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: Wrong MAC in redirected packet
Date: Wed, 25 Mar 2009 16:17:27 +0100
Message-ID: <17e3a8f80903250817i3aa80b49i9cb57d10f704e123@mail.gmail.com>
References: <17e3a8f80903250727q739fac53r6325a8eefff96a97@mail.gmail.com>
	 <alpine.LSU.2.00.0903251528420.19598@fbirervta.pbzchgretzou.qr>
	 <17e3a8f80903250800q15964da1gaf24ff1670ba3802@mail.gmail.com>
	 <alpine.LSU.2.00.0903251603050.18819@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:34668 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670AbZCYPRb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2009 11:17:31 -0400
Received: by bwz17 with SMTP id 17so84818bwz.37
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Mar 2009 08:17:27 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0903251603050.18819@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>>>>My theory is that the original MAC-address is somehow added to the SKB
>>>>before it reaches the output-part of the RAW-table (which is where I
>>>>hook in),
>>>
>>> Routing is done before rawpost, yes, but before the (traditional) raw table.
>>> (it's in skb->dst)
>>
>>Ok, I assumed that the MAC-header was added at a lower layer, but that
>>was then wrong? For some reason I have always though skb->dst was the
>>IP-adress, I will look into that field.
>
> skb->dst contains the pointer to the neighbor (simply put), and a
> neighbor is (also simplified) what you see in `ip neigh`, i.e. MAC

Thanks.

>>After struggling a bit with the compilation (I had to remove the
>>iptable_rawpost.o ip6table_rawpost.o in Kbuild or the compiler
>>complained that it couldn't find the files), I get this error when I
>>try to use it:
>>
>>kristrev@mylatop:~/src/xtables-addons-1.12$ sudo iptables -A
>>PREROUTING -t raw -p udp -d 192.168.101.14 --dport 9999 -j RAWDNAT
>>--to-destination 192.168.100.250
>>iptables: Invalid argument
>
> See `dmesg` for the details of EINVAL.

[22480.722995] xt_RAWNAT may only be used in the "raw" or "rawpost" table.

When outputting the name of the table, I see that it is corrupted. I
tried to change the _check-function to use the new signature, but then
I got compilation-errors from the register-functions. I am using the
version of RAWNAT I found here [1] (please let me know if there is a
more recent one) and xtables-1.12.

-Kristian
