From: "Jim Fleming" <JimFleming@ameritech.net>
Subject: Re: disturbing MTU experiment
Date: Tue, 8 Apr 2003 13:46:11 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <007601c2fdff$20a81790$8500a8c0@repligate>
References: <20030408154101.13919.89741.Mailman@kashyyyk> <16018.64600.149601.372694@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Don Cohen" <don-netfil@isis.cs3-inc.com>,
	<netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Are you on the AM Internet or the FM InterNAT ?

128-bit DNS AAAA Record Flag Day Formats
2003:[IPv4]:[SDLL.OFFF.FFFF.TTTT]:[64-bit IPv8 or IPv16 Persistent Address]
[YMDD]:[IPv4]:[SDLL.OFFF.FFFF.TTTT]:[64-bit IPv8 or IPv16 Persistent Address]
1-bit to set the Reserved/Spare ("AM/FM") bit in Fragment Offset [S]
1-bit to set the Don't Fragment (DF) bit [D]
2-bits to select 1 of 4 common TTL values (255, 128, 32, 8) [LL]
1-bit for Options Control [O]
7-bits to set the Identification Field(dst) [FFFFFFF]
4-bits to set the TOS(dst) Field [TTTT]
Default SDLL.OFFF.FFFF.TTTT = 0000.0000.0000.0000
FFF.FFFF.TTTT = GGG.SSSS.SSSS
http://www.ntia.doc.gov/ntiahome/domainname/130dftmail/unir.txt
IPv8
0QQQQGGGSSSSSSSS[32-bits][Port]
IPv16
0QQQQGGGSSSSSSSS[32-bits][Port]
1AAAAAAAAAAAAAAA[32-bits][Port]
A...A=ASN=32769...65535

Jim Fleming
http://www.IPv8.info

----- Original Message ----- 
From: "Don Cohen" <don-netfil@isis.cs3-inc.com>
To: <netfilter-devel@lists.netfilter.org>
Sent: Tuesday, April 08, 2003 11:44 AM
Subject: disturbing MTU experiment


> 
> (Let me know if there's a more appropriate place to send this.)
> 
> My understanding of IPv4 is that
> - the forwarding path between two machines might have links of
>   different MTUs,
> - when an IP datagram marked DF is too big for one of those links, the
>   machine that would otherwise forward it is supposed to return an
>   ICMP unreachable reply
> - the sending machine is supposed to react to that ICMP reply, either
>   by sending a smaller datagram or by allowing fragmentation or of
>   course, giving up.
> 
> The following experiment ought to exhibit this behavior:
> 
>  internet --- eth0:linux_firewall:eth1 --- client
> 
> - on linux firewall do
>   ifconfig eth1 mtu 1400
> - on client machine try to use the internet, e.g., run a web browser
> 
> When I do this I find, to my dismay, that MANY sites don't work!
> A tcpdump on the firewall shows the web server in the internet sending
> a DF packet of size 1500, the firewall sending the ICMP reply, and the
> server ignoring it, i.e., resending the large packet over and over.
> 
> 1. Is there something wrong with my experiment or is a large part of
> the internet really broken in this way?  Do others out there see the
> same thing?
> 
> If I am correct, then
> 
> 2. What's the cause of this breakage?  Are servers filtering ICMP due
> to attacks?  Are they behind firewalls that don't know how to forward
> the ICMP packets?  Are ISPs filtering the ICMP packets?  Are the
> servers themselves running broken network code?  If so, which are the
> OS's with this defect?
> 
> 3. Are links with MTU < 1500 are extremely rare in the internet?
> The fact that the internet mostly seems to work would suggest that.
> Surely this has not always been the case.  When did it happen?
> Wouldn't this break various tunneling protocols?  At least those that
> try to encapsulate one packet in one IP packet.  Maybe those are also
> not much used?
> 
> 4. What can be done about it?  For instance, what would happen if
> the machines that send ICMP replies were to go ahead and fragment 
> the DF packets (perhaps instead of sending out a second ICMP to the
> same offender)?  
> 
