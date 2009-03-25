From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Wrong MAC in redirected packet
Date: Wed, 25 Mar 2009 16:20:39 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903251619380.18819@fbirervta.pbzchgretzou.qr>
References: <17e3a8f80903250727q739fac53r6325a8eefff96a97@mail.gmail.com>  <alpine.LSU.2.00.0903251528420.19598@fbirervta.pbzchgretzou.qr>  <17e3a8f80903250800q15964da1gaf24ff1670ba3802@mail.gmail.com>  <alpine.LSU.2.00.0903251603050.18819@fbirervta.pbzchgretzou.qr>
 <17e3a8f80903250817i3aa80b49i9cb57d10f704e123@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49376 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762691AbZCYPUm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2009 11:20:42 -0400
In-Reply-To: <17e3a8f80903250817i3aa80b49i9cb57d10f704e123@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-03-25 16:17, Kristian Evensen wrote:
>>>
>>>kristrev@mylatop:~/src/xtables-addons-1.12$ sudo iptables -A
>>>PREROUTING -t raw -p udp -d 192.168.101.14 --dport 9999 -j RAWDNAT
>>>--to-destination 192.168.100.250
>>>iptables: Invalid argument
>>
>> See `dmesg` for the details of EINVAL.
>
>[22480.722995] xt_RAWNAT may only be used in the "raw" or "rawpost" table.
>
>When outputting the name of the table, I see that it is corrupted. I
>tried to change the _check-function to use the new signature, but then
>I got compilation-errors from the register-functions. I am using the
>version of RAWNAT I found here [1] (please let me know if there is a
>more recent one) and xtables-1.12.

I will look into rebasing RAWNAT to a newer Xt-a.
