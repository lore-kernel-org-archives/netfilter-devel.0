From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Mon, 27 Dec 2010 16:23:28 +0000
Message-ID: <4D18BD80.2030807@googlemail.com>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <4D0CC3BB.8030801@googlemail.com> <alpine.DEB.2.00.1012182050280.11577@blackhole.kfki.hu> <4D0D2CF4.5070201@googlemail.com> <alpine.DEB.2.00.1012190105460.11753@blackhole.kfki.hu> <4D0E0E2A.3090604@googlemail.com> <4D0E22A5.8090808@conversis.de> <4D0E3B34.7090105@googlemail.com> <alpine.DEB.2.00.1012221146060.3482@blackhole.kfki.hu> <4D11F384.3070908@googlemail.com> <alpine.DEB.2.00.1012231558390.6044@blackhole.kfki.hu> <4D138C02.3050905@googlemail.com> <alpine.DEB.2.00.1012232008520.6582@blackhole.kfki.hu> <4D13CBD8.3090007@googlemail.com> <alpine.DEB.2.00.1012232337070.7027@blackhole.kfki.hu> <alpine.DEB.2.00.1012232354510.7109@blackhole.kfki.hu> <4D13D60C.3020304@googlemail.com> <alpine.DEB.2.00.1012261125100.9618@black
 hole.kfki.hu> <4D17475B.9000909@googlemail.com> <alpine.DEB.2.00.1012262034390.10148@blackhole.kfki.hu> <4D17B730.8040505@googlemail.com> <alpine.DEB.2.00.1012271517330.11100@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dennis Jacobfeuerborn <dennisml@conversis.de>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39541 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab0L0QXk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Dec 2010 11:23:40 -0500
In-Reply-To: <alpine.DEB.2.00.1012271517330.11100@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>> Whatever the appropriate place holder is - 'all', '*', '@', '$$$$$$' etc. etc
>> - as long as it does the job at the end it won't matter.
>>     
>
> It does matter. Non-intuitive syntax and notation are bad. Moreover, the 
> notation should be open to handle other protocols too (see below).
>   
What I meant was that whatever the prefix *you* decide to put in, for 
*me* it won't matter as long as it does its job.

>> I wasn't aware that there are more than 2 (tcp and udp) protocols on which I
>> could define/use ports!
>>     
>
> sctp, udplite.
>   
I learn something new every day. Then it makes even more sense to store 
the protocol as a number, not as string for easier matching - useful if 
you one day decide to apply masking (or other convenient form of 
searching) against the captured protocol (which could also be a number). 
;-)

>> What are your plans?
>>     
>
> Double check and triple check both the kernel and userspace of ipset 5. 
> Get more feedback, especially from uncommon architecture. Submit for 
> kernel inclusion. After that new features can be added.
>   
Fair enough. Any idea when ipset 5.2 will be incorporated into xtables 
so that I could download it and start testing it? *nudges Jan*

As it stands, I do not have enough information to build the rpm spec 
file in order to create a complete xtables rpm package to incorporate 
your version of ipset (without this I cannot distribute it across my 
test machines easily), so unless I am able to build this rpm the whole 
thing is a no go from me.

>> So, in other words 'internally' you store something like (using your example
>> above) 192.168.0.0 (the IP part), 30 (the prefix), tcp, 80 in the structure,
>> is that right?
>>     
>
> Yes, exactly.
>
>   
>> Do you then use the mask of each member of that set (30 and 24 in your example
>> above) until you get a match? In other words, you 'walk through' every
>> internally stored element and try their mask and then lookup for a match, is
>> that how you do it?
>>     
>
> Besides the elements, the different prefixes are also stored in the set. 
> So the test set in the example "knows" that the prefixes 30 and 24 occur 
> only and use only those to find a match, starting from the most speficic 
> prefix to the least one.
>   
If I understand you correctly, you keep a separate structure which 
stores all prefixes used in the target set, walk through that structure 
and for each element you build start-end range based on the IP address 
captured and the current prefix. You then create a hash on the 
calculated start-end range, protocol and port triple and then test that 
hash against the hash value of the target set triple (IP range, 
protocol, port). Is that how you do it?

I understand that things are a bit easier with hash:ip,protocol,port as 
you don't need to store prefixes - you just calculate the hashes and 
match them against the corresponding hashes of the set triple, right?

>>> However, the problem with iptree(map) is that it's susceptible when used as
>>> a container to block attackers dynamically by the SET target: it's trivial
>>> to mount an attack by which the worst tree structure is forced to be
>>> created.
>>>       
>> Could you expand on that bit please? What do you mean?
>>     
>
> The iptree(map) sets store the elements in a tree structure which follows 
> the dotted decimal notation of the IPv4 addresses. Let's assume, someone 
> catches attackers by a given match and stores their IP addresses in the 
> iptree type of set called "attackers":
>
> # If some matches are true, it's an attacker, store the address
> ...... -j SET attackers src
> # Drop known attackers
> .... -m set attackers src -j DROP
>
> What I referred to was that it's not hard to send forged packets, which 
> create the widest and least filled in (i.e. worst) tree structure. It does 
> not slow down the set but pushes it to the worst memory usage case.
>   
Couldn't the same be said for the hash (or any other?) ipsets as well? I 
am not using that 'feature' anyway, as I include the ip addresses/ranges 
manually from script files (though some of them are automatically 
generated and are based on the geoip database which is downloaded at 
regular intervals), so that 'vulnerability' does not apply to me.

> I regard it as a weakness of the type: an attacker must not be able to 
> trigger any worst case situation of a set type intentionally.
>   
How is that changed in the hash (or bitmap even) ipsets - would that not 
be the same then: an attacker crafts specifically designed packets to 
include certain ip/port ranges in a set (*a* set - it could be any set)?

I think the culprit is not the set itself, but the SET target as I find 
it rather foolish that someone would let an outsider to manipulate a set 
using this SET target. For example, if I am an attacker and I know that 
the target machine relies on access to certain IP address, then I could 
craft a packet in such a way that it triggers this SET target which then 
includes the IP address/range in the 'attackers' set and therefore 
disable access to that address on the target machine - job done!

