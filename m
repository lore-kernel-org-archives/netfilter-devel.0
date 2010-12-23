From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Thu, 23 Dec 2010 17:50:58 +0000
Message-ID: <4D138C02.3050905@googlemail.com>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <4D0CC3BB.8030801@googlemail.com> <alpine.DEB.2.00.1012182050280.11577@blackhole.kfki.hu> <4D0D2CF4.5070201@googlemail.com> <alpine.DEB.2.00.1012190105460.11753@blackhole.kfki.hu> <4D0E0E2A.3090604@googlemail.com> <4D0E22A5.8090808@conversis.de> <4D0E3B34.7090105@googlemail.com> <alpine.DEB.2.00.1012221146060.3482@blackhole.kfki.hu> <4D11F384.3070908@googlemail.com> <alpine.DEB.2.00.1012231558390.6044@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dennis Jacobfeuerborn <dennisml@conversis.de>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1012231558390.6044@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


> The algorithm does not allow to ignore the protocol part. That's the 
> reason why double lookup would be needed if such syntactic sugar as 
> 'tcpudp' were introduced. Lets assume we store in the artifical set above 
> two elements:
>
> 192.168.0.1,tcpudp:53
> 192.168.0.1,tcp:80
>
> Now, assuming that first 'tcpudp' is looked up, to match the first 
> element, we need one lookup. To check the existence of the second element, 
> we have to use two lookups: first with '192.168.0.1,tcpudp:80' (nomatch),
> then with '192.168.0.1,tcp:80'. And to check the existence of any 
> non-matching element (say 192.168.0.1,udp:123) needs again two lookups.
>   
Then your matching algorithm is wrong!

Using your example above, I'd add the following change: the protocol 
specifier could be converted (internally) to a number: 1 - tcp (1 in 
binary form), 2 - udp (10 in binary form), 3 - 'tcp and udp' (11 in 
binary form). When you need to match against a real protocol (which, if 
I am not mistaken, can only be either tcp or udp), then you can use 
binary 'and' operation (&) with one simple statement to determine 
whether there is a match. Using your example above, we will have the 
following (internal) representation:

192.168.0.1,3,53
192.168.0.1,1,80

Thus, to check for 192.168.0.1:53 (tcp) - there will be a match as when 
you apply 1) ip match; and 2) protocol match - i.e. 1 & 3 (1 & 11) you 
will get >0, therefore protocol matches; and 3) port match, there is a 
match on all 3 elements, hence return a complete match. Just one lookup 
needed.

When you have 192.168.0.1:53 (udp) the situation is exactly the same as 
far as the protocol goes - 2 & 3 (10 & 11) you will get > 0, hence there 
is a match again. Just one lookup needed.

When you have 192.168.0.1:80 (tcp) - you will have a match on the ip and 
protocol, bit mismatch on the port, so no match - you also need one lookup.

You have exactly the same scenario with 192.168.0.1:123 (udp) - match on 
the ip and protocol part, but mismatch on the port, so no match!

> Such a hack thus would penalize the normal cases.
>   
There is no need for a 'hack' just sensible and efficient programming, 
that's all.

>   
>   
>> I am not sure I understand you.
>>     
>
> If you need to match the same port both with TCP and UDP, then add it 
> to the set twice, with the proper protocols.
>   
I've already dealt with this - I do not see the need to add 2x as many 
elements to a set when, in reality, I am not interested in matching the 
protocol part.

  

>> There is a problem with this - the 'bond' which exists with (the imaginary and
>> working) hash:ip,all,port (i.e. the implicit link between the element's ip
>> address/subnet and the port or port range)  is not there if two separate sets
>> are used!
>>
>> [...]
>>     
>
> Yes, therfore my assumption was that the ports are uniform, identical for 
> all elements.
>   
An isolated case and one which does not apply to a common scenario.

>> You already mentioned DNS, I'd add DHCP to that list as well as VPN, 
>> IPSec and Kerberos traffic, which could be either tcp or udp on the same 
>> port numbers. 
>>     
>
> DHCP uses UDP only.
You are mistaken - DHCPv6 (client as well as server configurations) uses 
both TCP and UDP protocols on the same port numbers.


>  VPN (e.g OpenVPN) can be configured to use UDP or TCP, 
> but not both at the same time.
You are assuming that I will have a single machine on which VPN is 
running, which, again, is an isolated case. When I have a central hub, 
which controls multiple subnets VPN packets can originate from (or be 
destined to) the same port numbers using TCP as well as UDP protocols.

>  For ipset point of view, IPSec is an 
> independent (actually, two, AH and ESP) protocol. Kerberos uses a couple 
> of TCP and UDP ports, but not both with the same port number (except for 
> changing password under Windows, if you have to support both the old and 
> new interfaces).
>   
Again, not true and you are assuming I am running a single machine - 
that is not the case at all.

Kerberos remote login, change password (except klogin which uses tcp 
only), administration and kreg can all be ran using either tcp or udp on 
the same port numbers. As for IPSec - the situation is exactly the same 
- port 1293 with either tcp or udp utilised.

>> VOIP (including STUN, RTP and SIP) is another example - not only the 
>> port numbers vary wildly within (usually) pre-defined group, but could 
>> utilise tcp as well as the udp protocol on these ports. IRC
>>     
>
> STUN uses a single port over TCP and UDP.
Yep, that's right - both protocols could be used on the same port.

>  RTP may run over TCP but the 
> majority of the applications uses UDP only.
Again, utilising TCP is not as uncommon as you might think - TCP gives 
you better line quality when you have good (optical for example) network 
and it is also the preferred option when you utilise encrypted data 
streams. Same goes for SIP.

>  SIP is complex... IRC uses TCP 
> only.
>   
IRC on Port 194, protocols could be either TCP or UDP, again, depending 
on the configuration. AOL instant messenger also utilises both tcp and 
udp protocols on the same port (531).


>>  or even LDAP. Various databases (MySQL, PostgreSQL and Oracle to name a 
>> few) also utilise both protocols on the same port numbers.
>>     
>
> LDAP and *SQL use TCP only.
>   
Wrong again! Check the documentation for the databases I mentioned 
properly and you will see that MySQL could use 3306 utilising both tcp 
and udp protocols, PostgreSQL can also utilise both protocols on its 
common port (5432) and with the case of Oracle - although the commonly 
used Oracle port is 1521 it also utilises ports 2483 (for insecure) and 
2484 (for secure) client connections replacing the 'old' 1521 port for 
insecure client connections.

