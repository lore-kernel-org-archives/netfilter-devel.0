From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Mon, 27 Dec 2010 18:52:32 +0000
Message-ID: <4D18E070.6010107@googlemail.com>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <4D0D2CF4.5070201@googlemail.com> <alpine.DEB.2.00.1012190105460.11753@blackhole.kfki.hu> <4D0E0E2A.3090604@googlemail.com> <4D0E22A5.8090808@conversis.de> <4D0E3B34.7090105@googlemail.com> <alpine.DEB.2.00.1012221146060.3482@blackhole.kfki.hu> <4D11F384.3070908@googlemail.com> <alpine.DEB.2.00.1012231558390.6044@blackhole.kfki.hu> <4D138C02.3050905@googlemail.com> <alpine.DEB.2.00.1012232008520.6582@blackhole.kfki.hu> <4D13CBD8.3090007@googlemail.com> <alpine.DEB.2.00.1012232337070.7027@blackhole.kfki.hu> <alpine.DEB.2.00.1012232354510.7109@blackhole.kfki.hu> <4D13D60C.3020304@googlemail.com> <alpine.DEB.2.00.1012261125100.9618@blackhole.kfki.hu> <4D17475B.9000909@googlemail.com> <alpine.DEB.2.00.1012262034390.10148@black
 hole.kfki.hu> <4D17B730.8040505@googlemail.com> <alpine.DEB.2.00.1012271517330.11100@blackhole.kfki. hu> <4D18BD80.2030807@googlemail.com> <alpine.DEB.2.00.1012271854400.11291@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dennis Jacobfeuerborn <dennisml@conversis.de>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39234 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab0L0Swo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Dec 2010 13:52:44 -0500
In-Reply-To: <alpine.DEB.2.00.1012271854400.11291@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>> Fair enough. Any idea when ipset 5.2 will be incorporated into xtables so that
>> I could download it and start testing it? *nudges Jan*
>>     
>
> You constantly ignore the difference between xtables and xtables-addons...
>   
You know exactly what I meant.

>> If I understand you correctly, you keep a separate structure which stores all
>> prefixes used in the target set, walk through that structure and for each
>> element you build start-end range based on the IP address captured and the
>> current prefix. You then create a hash on the calculated start-end range,
>> protocol and port triple and then test that hash against the hash value of the
>> target set triple (IP range, protocol, port). Is that how you do it?
>>     
>
> No, there's no point to store start-end ranges: the network address and 
> the prefix is stored, which thus require less memory compared to the 
> range.
>   
OK, so you store IP address and then the range. Do you then perform the 
process as I described above in order to find a match?

>> I think the culprit is not the set itself, but the SET target as I find it
>> rather foolish that someone would let an outsider to manipulate a set using
>> this SET target. For example, if I am an attacker and I know that the target
>> machine relies on access to certain IP address, then I could craft a packet in
>> such a way that it triggers this SET target which then includes the IP
>> address/range in the 'attackers' set and therefore disable access to that
>> address on the target machine - job done!
>>     
>
> Of course, it's absolutely possible. However in order to slow down for 
> example ssh scanning, even short time blocking of the addresses from 
> which scanning is detected can be quite useful.
>   
Anything which manipulates the internal structure from outside is, in my 
opinion, not a good idea for the reason I mentioned above.

On a separate note, once I've installed ipset 5.2 I am very keen on 
testing both type of sets (iptreemap and the new hash set) to see what 
is the performance penalty with the new sets (there will probably be one 
as your search algorithm is more complex in 5.x and would require more 
iterations compared with the 4.x type sets).
