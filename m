From: Peter Stamfest <peter@stamfest.at>
Subject: Introducing iptables-snmp...
Date: Wed, 19 Mar 2003 12:02:27 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0303191155100.24978-100000@peter.stamf.pr.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello everybody, 

I have just put up a very alpha version of my iptables-over-SNMP software 
for download on http://oss.stamfest.net/iptables-snmp/

It provides for basic access to iptables information via SNMP using the 
net-snmp (http://www.net-snmp.org/) SNMP agent.

A MIB is provided as well.

It also requires iptables-1.2.7a (+a small patch to introduce 
"iptc_free" - I would suggest to actually apply this patch to the 
iptables-distribution) - it uses the libiptc.a library.

Currently it provides for access to packet and bytes counters and some 
information about the rules. However, currently it does not provide for 
information about extension modules due to the lack(?) of a reasonable 
interface to access such information via iptables..

Also it has no support for IPv6.

Have a look at the README file for build-instructions. No thoughts went 
into making it user-friendly so far ;-)  This is experimental!

I am most interested in any feedback. I am willing to contribute this 
software to iptables proper if there is interest in this.

peter
