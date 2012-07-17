From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: pgsql-ulogd2
Date: Wed, 18 Jul 2012 00:29:36 +0100
Message-ID: <5005F560.8070200@googlemail.com>
References: <50002CEF.508@googlemail.com> <1342194935.11019.12.camel@tiger.regit.org> <50016D84.5080207@googlemail.com> <1342300959.6098.8.camel@tiger.regit.org> <5002B688.4070907@googlemail.com> <1342385528.8476.2.camel@tiger.regit.org> <500345F1.3050407@googlemail.com> <20120716080013.GA522@breakpoint.cc> <50040E96.5050005@googlemail.com> <20120716132759.GB522@breakpoint.cc> <20120716152815.GA28284@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, Eric Leblond <eric@regit.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40719 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab2GQX3l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Jul 2012 19:29:41 -0400
Received: by wgbdr13 with SMTP id dr13so814053wgb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Jul 2012 16:29:39 -0700 (PDT)
In-Reply-To: <20120716152815.GA28284@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>> iptables -t raw -A PREROUTING -i eth0 -o eth7 \
>> 	 -s 192.168.1.0/24 -j CT --ctevents new,related,destroy
>>     
>
> It should be hard to add some "none" for --ctevents so you can add to
> the following rules below:
>
> iptables -t raw -A PREROUTING -i eth0 -o eth7 \
> 	 -s 192.168.1.0/24 -j CT --ctevents new,related,destroy
> iptables -t raw -A PREROUTING -i eth0 -o eth7 \
> 	 ! -s 192.168.1.0/24 -j CT --ctevents none
>
> Not to report events for others. Note that the "none" is missing now
> in iptables.
>
> Thus, we will only get events coming from 192.168.1.0/24.
>   
I am not entirely certain whether I could do more damage to my setup if 
I do the above. Let me explain:

On all interfaces, with the exception of one, I have a limited set of 
rules, which are traversed only when a new connection is established 
(i.e. the state is NEW). In all other cases, I have -j ACCEPT when the 
state is RELATED or ESTABLISHED. This was done primarily to lower the 
load on the firewall machine and also to save me from writing iptables 
rules for both sides of a connection.

I am not sure if I apply the above, how would that affect the setup I 
just described and I am not sure whether it would make things worse. 
Again, my aim is to be able to configure full logging of particular type 
of connections via NFCT (from their inception to their closure), 
depending on the interface and source/destiantion IP address/subnet, 
possibly without affecting the above setup too much.

I know how to do that with packets via NFLOG - that is easy enough for 
me, but I am struggling with NFCT, unfortunately.
