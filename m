From: "PAUL FABRICIO VILLACRESES LEON" <paulvillacreses@hotmail.com>
Subject: How block port tcp using library iptables
Date: Fri, 03 Jan 2003 01:08:21 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <F84Kljq65Rn8P5o7P6u000007a2@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: sumit@elitecore.com
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org




Hi

Sumit Pandya and all netfilter-devel's menbers

white Paul Villacreses Leon
Student
ESPOL UNIVERSIY - ECUADOR

topic :contents transparent firewall

I have this:

Internet -----| eth0 | -------  bridge --------- | eth1 | ---- LAN Proteted

1.- I Used linux RedHat 8 kernel linux2.4.18-19
2.- I use the module bridge.o for bridge eth0 to eth1
2.- I have a C program , this capture packets .
3.- I use libpcap.a  to capture the packet and libiptc.a(iptables1.2.6.a) 
for block

4.- whith libiptc.a read rules in iptables and add new rules in chain 
FORWARD
5.- My program put the rule and block ip_src,ip_dst asn ip_p(IP protocol)

But I need :

1.- Block port TCP like (ftp 21 ,telnet 23,DNS 53, tftp 69 snmp 161 etc..)
2.- The library libiptc whith yours struct ipt_entry don't enable me block 
port tcp
3.- Redirect with NAT but using a library not script

2 questions?

How block port tcp using library libiptc or another libraty?
i read about struct ipt_tcp but i don't understand when i work whith this 
struct.

In the library  libiptc.a create new rule is basic only suport ACCEPT, DROP, 
RETURN
i need to accept DNAT and SNAT. How enable this.

Please answer me

thank you very much






>From: "Sumit Pandya" <sumit@elitecore.com>
>To: "PAUL" <paulvillacreses@hotmail.com>
>CC: <netfilter-devel@lists.samba.org>
>Subject: RE: Request for a Beginning in libiptc and libipq
>Date: Thu, 28 Mar 2002 19:24:19 +0530
>
>Hi Paul,
>	I'm still not sure why you wanted to automate such process at kernel 
>level.
>But Its really an interesting thought. Ya It took a little long time to 
>move
>on your problem, but I've a hope to achieve this. You know me too usually
>take interest in such adventures, so I took you personally ;-)
>	Anyway from your description I'd define your goal as "Making System Calls
>from Kernel Space". I got this idea by khttpd module of kernel, and I got
>same deal on Internet from website of very popular Linux Identity
>"Alessandro Rubini". Just go through his guide on link
>http://www.linux.it/kerneldocs/ksys/ksys.html.
>
> >> 2.- Can I use libiptc or another lib or *.h  for manipulate the packet
>and
> >> compare with a file with IP's and enable go to the QUEUE without 
>scripts
> >> below, for example:
> >> iptables -I FORWARD -j QUEUE or
> >> iptables -t mangle -I PREROUTING -j QUEUE
>	To achieve this you require to write your own "Target" for netfilter, like
>ACECPT,REJECT,... Easiest to look into target "TOS".
>
> >> 3.- Why using table  "mangle" for sent the packet to the QUEUE  in
> >> PREROUTING  the catch of the packet  is more fast than using the QUEUE 
>in
> >> the table "filter" in FORWARD.
>	It depends on which traffic you wanted to intercept. If you Implement 
>QUEUE
>in FORWARD then you will miss all those packets ehich intended to host. 
>Just
>a Silly question here: Do you have clear idea of how packet travel into
>netfilter code? Which chains are travel and in which order? Don't get
>annoyed, from yours "see the comments...Step Table Chain Comment... " I can
>say that you have little idea atleast ;-).
>
> >> 4.- In the HOW-TO hacking-netfilter i read some functionality using
>KERNEL
> >> function for add rules i read this but How can I do ?
>	It would be nice if you snapped that part of documentation in this mail.
>
>-- Sumit
>


_________________________________________________________________
MSN 8 with e-mail virus protection service: 2 months FREE* 
http://join.msn.com/?page=features/virus
