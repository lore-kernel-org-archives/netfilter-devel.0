From: "Fabien C." <7o5fzvj4duxjxzp@jetable.org>
Subject: Re: libnetfilter_queue: Some accepted packets get lost
Date: Thu, 10 Mar 2011 00:27:15 +0100
Message-ID: <4D780CD3.2000006@jetable.org>
References: <4D716FFE.8050503@jetable.org> <4D778432.10802@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:39478 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab1CIX1X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2011 18:27:23 -0500
In-Reply-To: <4D778432.10802@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Pablo,

>> 01) 20:08:00.486366: recv returned 108
>> 02) 20:08:00.486566: setting verdict : accept the packet...
>> 03) 20:08:00.486614 IP 10.3.5.8.46938 > 10.3.5.1.53: 51146+ A? www.mydomain.net. (35)
>> 04) 20:08:00.487193 IP 10.3.5.1.53 > 10.3.5.8.46938: 51146 1/3/3 A 12.34.123.210 (157)
>> 05) 20:08:00.586723: recv returned 108
>> 06) 20:08:00.586789: setting verdict : accept the packet...
>>  [==> tcpdump doesn't see this one - so browser waits for 5sec, and retries]
> 
> Check for errors in recv() to see if you are hitting ENOBUFS.

Nope. recv() seems to be fine. As you can see from the output I gave in my
first message, it always returns positive values "recv returned 108".

For the record, I must add: I compiled a custom 2.6.32 and surprisingly still
have the problem. Is it my config, or the Debian patches that make the
difference, I don't know...

Fabien
