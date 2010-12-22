From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Wed, 22 Dec 2010 12:48:04 +0000
Message-ID: <4D11F384.3070908@googlemail.com>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <4D0CC3BB.8030801@googlemail.com> <alpine.DEB.2.00.1012182050280.11577@blackhole.kfki.hu> <4D0D2CF4.5070201@googlemail.com> <alpine.DEB.2.00.1012190105460.11753@blackhole.kfki.hu> <4D0E0E2A.3090604@googlemail.com> <4D0E22A5.8090808@conversis.de> <4D0E3B34.7090105@googlemail.com> <alpine.DEB.2.00.1012221146060.3482@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dennis Jacobfeuerborn <dennisml@conversis.de>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1012221146060.3482@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


> I could not come up with a good solution. It is not possible to avoid
> double lookup in the set if the elements may have (say hash:ip,port type 
> of set) the forms:
>
> ipaddr,tcp:port
> ipaddr,udp:port
> ipadd,tcpudp:port
>   
I was thinking that you may interpret either the absence of the protocol 
specification ('tcp', 'udp' and 'tcpudp' in your examples above) or the 
word 'all' (even '*' though I don't know if that's possible) to mean 
that no protocol match is necessary.

> But if the double-lookup is required, then better add all tcp and udp port 
> variants and go with a single-lookup.
>   
I am not sure I understand you.

> Or if you have uniform ports for all elements, you can use two set 
> matches:
>
> ipset create hash:ip ipaddrs
> ipset create bitmap:port ports
>
> ... -m set --match-set ipaddrs dst -m set --match-set ports dst ...
>   
There is a problem with this - the 'bond' which exists with (the 
imaginary and working) hash:ip,all,port (i.e. the implicit link between 
the element's ip address/subnet and the port or port range)  is not 
there if two separate sets are used!

In order to create this 'bond' I have to use not one, but two separate 
sets (i.e. vpn_hosts/vpn_ports) and even then I cannot control this fully.

One very simple example: if I have a vpn host group which is on the 
10.1.1.0/24 subnet and operates within the 1194 (tcp/udp) port range and 
then have another vpn host group 10.1.2.0/24 which operates on a 
different port range - 80,443 (tcp and udp).

If I follow your example above I have to define *four* sets to 
accommodate the double matches, because if I put all the vpn ports into 
one ipset group (say vpn-ports) which contains ports 1194,80 and 443 and 
then use a similar ipset for the vpn hosts (say vpn-hosts) containing 
10.1.1.0/24 and 10.1.2.0/24 as its members and then do a double match 
"-m set --match-set vpn-hosts dst -m set --match-set vpn-ports dst" that 
would mean packets destined to 10.1.1.0/24 on ports 80,443 (tcp/udp) and 
10.1.2.0/24:1194 (tcp,udp) will be allowed which is not what I want.

If I want to separate this fully and make it work as it should, I have 
to define *four* sets (vpn-hosts1->10.1.1.0/24, vpn-ports1->1194, then 
vpn-hosts2->10.1.2.0/24,vpn-ports2->80,443), which makes the whole job 
rather cumbersome. I currently have this problem when I employ a similar 
approach with the existing 4.x version of ipset.

If ipset 5.x can disregard the protocol match I will have to define a 
single set and place just 3 members in it: 10.1.1.0/24,all,1194; 
10.1.2.0/24,all,80 and 10.1.2.0/24,all,443

