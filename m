From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: Linux Routers working
Date: Sat, 04 Jun 2005 09:08:44 +0000
Message-ID: <42A16F9C.5070007@outerspace.dyndns.org>
References: <20050513060939.18564.qmail@web41422.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: cranium2003 <cranium2003@yahoo.com>
In-Reply-To: <20050513060939.18564.qmail@web41422.mail.yahoo.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Quoting cranium2003 on 2005-05-13 06:09 UTC:
>> iptables -A FORWARD -i eth0 -o eth1 ...
> 
> Can i get that information thru' C program user/kernel mode netfilter
> program? Because you have given the rule to forward packet but what
> if Router have 3 or 4 NIC network interfaces? I want to print 
> somrthing like LOG that prints that packet has srcip and dstip and is
> going through eth0/eth1/eth2/eth3.

In the kernel it's surely available.. In userspace, ULOG might give the
information, I'm not sure..

>>> Also before packet processed by IP layer can it be possible to
>>> know from which adjecent Router'IP packet came to that router?
>> 
>> No, but the MAC address is available. You just have to find out
>> what the mac address of the router in question and do:
>> 
>> iptables -A INPUT -m mac --mac-source 01:23:45:67:89:AB ...
> 
> No suppose i have no info about adjecent routers mac addresses and
> when packet came at destination Router at Link layer/IP layer can i 
> determine from which router the packet came to destination router?

Well the mac address is the only way to tell which adjecent router the
packet came from. You could use the arp table to determine the ip of
that router.

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCoW+axyF48ZTvn+4RAq5VAKCv+U09k0cWZ1zsnvqXsGKG/T46ewCgk5bf
d7dlNXN7WYET32UTyH8VVVA=
=G2Nt
-----END PGP SIGNATURE-----
