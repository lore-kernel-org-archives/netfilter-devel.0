From: "Ranjeet Shetye" <ranjeet.shetye@zultys.com>
Subject: How do I add a 1:1 port-forwarding capability for a DNAT port-range to NetFilter ?
Date: Fri, 13 Dec 2002 10:01:32 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000d01c2a2d1$ab576050$0100a8c0@zultys.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


This is what I posted on the user-mailing list yesterday.

---------------------------------------------------------------
DNAT:

Is it possible to have a SINGLE (DNAT?) rule that will let me do 1:1
port-forwarding over a range of ports while doing Destination NAT.

e.g. Any incoming connections to 64.1.0.20:100-101 need to be mapped to
172.16.0.100:200-201 for the TCP protocol.
such that a connection to port 101 will ALWAYS map to port 201 and a
connection to port 100 will ALWAYS map to port 200.

Under current DNAT port range scenario, the connection goes to the
lowest port that is free e.g. a port 101 connection will be DNATt'ed to
port 200 if port 200 is free.

The reason for wanting a 1:1 rule is for X windows and other fat port
ranges. Dont want hundreds of rules in there if one can do the job. Can
IPTables do it ? If so how ? If not, I guess I'll have to get in touch
with the developers for tips on a good starting point.
---------------------------------------------------------------

The answer I got is that basically I have to modify the nat code. I have
been reading the code for the last 2-3 days but I am competely lost as
to where to start. Should I make the change in ip_nat_setup_info or
get_unique_tuple or manip_pkt ? Any pointers/any help here is
appreciated.

Also, if anyone has an architectural diagram of NetFilter :D (mapping
out the interactions between the various layers/components), that would
be heaven!!!

Thanks in advance,

Ranjeet Shetye
Senior Software Engineer
Zultys Technologies
771 Vaqueros Avenue
Sunnyvale  CA  94085
USA
Ranjeet.Shetye@Zultys.com
http://www.zultys.com/

 
