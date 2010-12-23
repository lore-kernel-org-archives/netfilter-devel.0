From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Thu, 23 Dec 2010 16:39:53 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012231558390.6044@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <4D0CC3BB.8030801@googlemail.com> <alpine.DEB.2.00.1012182050280.11577@blackhole.kfki.hu> <4D0D2CF4.5070201@googlemail.com> <alpine.DEB.2.00.1012190105460.11753@blackhole.kfki.hu>
 <4D0E0E2A.3090604@googlemail.com> <4D0E22A5.8090808@conversis.de> <4D0E3B34.7090105@googlemail.com> <alpine.DEB.2.00.1012221146060.3482@blackhole.kfki.hu> <4D11F384.3070908@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dennis Jacobfeuerborn <dennisml@conversis.de>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4D11F384.3070908@googlemail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 22 Dec 2010, Mr Dash Four wrote:

> > I could not come up with a good solution. It is not possible to avoid
> > double lookup in the set if the elements may have (say hash:ip,port type of
> > set) the forms:
> > 
> > ipaddr,tcp:port
> > ipaddr,udp:port
> > ipadd,tcpudp:port
> >   
> I was thinking that you may interpret either the absence of the protocol
> specification ('tcp', 'udp' and 'tcpudp' in your examples above) or the word
> 'all' (even '*' though I don't know if that's possible) to mean that no
> protocol match is necessary.

The algorithm does not allow to ignore the protocol part. That's the 
reason why double lookup would be needed if such syntactic sugar as 
'tcpudp' were introduced. Lets assume we store in the artifical set above 
two elements:

192.168.0.1,tcpudp:53
192.168.0.1,tcp:80

Now, assuming that first 'tcpudp' is looked up, to match the first 
element, we need one lookup. To check the existence of the second element, 
we have to use two lookups: first with '192.168.0.1,tcpudp:80' (nomatch),
then with '192.168.0.1,tcp:80'. And to check the existence of any 
non-matching element (say 192.168.0.1,udp:123) needs again two lookups.

Such a hack thus would penalize the normal cases.

> > But if the double-lookup is required, then better add all tcp and udp port
> > variants and go with a single-lookup.
> >   
> I am not sure I understand you.

If you need to match the same port both with TCP and UDP, then add it 
to the set twice, with the proper protocols.
 
> > Or if you have uniform ports for all elements, you can use two set matches:
> > 
> > ipset create hash:ip ipaddrs
> > ipset create bitmap:port ports
> > 
> > ... -m set --match-set ipaddrs dst -m set --match-set ports dst ...
> >   
> There is a problem with this - the 'bond' which exists with (the imaginary and
> working) hash:ip,all,port (i.e. the implicit link between the element's ip
> address/subnet and the port or port range)  is not there if two separate sets
> are used!
> 
> In order to create this 'bond' I have to use not one, but two separate sets
> (i.e. vpn_hosts/vpn_ports) and even then I cannot control this fully.
> 
> One very simple example: if I have a vpn host group which is on the
> 10.1.1.0/24 subnet and operates within the 1194 (tcp/udp) port range and then
> have another vpn host group 10.1.2.0/24 which operates on a different port
> range - 80,443 (tcp and udp).
> 
> If I follow your example above I have to define *four* sets to accommodate the
> double matches, because if I put all the vpn ports into one ipset group (say
> vpn-ports) which contains ports 1194,80 and 443 and then use a similar ipset
> for the vpn hosts (say vpn-hosts) containing 10.1.1.0/24 and 10.1.2.0/24 as
> its members and then do a double match "-m set --match-set vpn-hosts dst -m
> set --match-set vpn-ports dst" that would mean packets destined to 10.1.1.0/24
> on ports 80,443 (tcp/udp) and 10.1.2.0/24:1194 (tcp,udp) will be allowed which
> is not what I want.
> 
> If I want to separate this fully and make it work as it should, I have to
> define *four* sets (vpn-hosts1->10.1.1.0/24, vpn-ports1->1194, then
> vpn-hosts2->10.1.2.0/24,vpn-ports2->80,443), which makes the whole job rather
> cumbersome.

Yes, therfore my assumption was that the ports are uniform, identical for 
all elements.

You wrote earlier:

> > Why would you want to match a port for all protocols? Do you have a
> > specific example for that?

> You already mentioned DNS, I'd add DHCP to that list as well as VPN, 
> IPSec and Kerberos traffic, which could be either tcp or udp on the same 
> port numbers. 

DHCP uses UDP only. VPN (e.g OpenVPN) can be configured to use UDP or TCP, 
but not both at the same time. For ipset point of view, IPSec is an 
independent (actually, two, AH and ESP) protocol. Kerberos uses a couple 
of TCP and UDP ports, but not both with the same port number (except for 
changing password under Windows, if you have to support both the old and 
new interfaces).

> VOIP (including STUN, RTP and SIP) is another example - not only the 
> port numbers vary wildly within (usually) pre-defined group, but could 
> utilise tcp as well as the udp protocol on these ports. IRC

STUN uses a single port over TCP and UDP. RTP may run over TCP but the 
majority of the applications uses UDP only. SIP is complex... IRC uses TCP 
only.

> and media streaming too, not to mention the (notoriously bad) Microsoft 
> NetBIOS (ports 135, 137, 138 and 139), WINS

>  or even LDAP. Various databases (MySQL, PostgreSQL and Oracle to name a 
> few) also utilise both protocols on the same port numbers.

LDAP and *SQL use TCP only.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
