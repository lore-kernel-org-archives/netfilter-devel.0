From: "Henrik Nordstrom" <hno@marasystems.com>
Subject: Re: Idea: Check session source and destination
Date: Sun, 23 May 2004 12:54:13 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1979.80.53.224.38.1085309653.gloport@www.tmuras.2000.cd>
Reply-To: nexor@mybaby.cd
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Cc: "Netfilter Developers List  netfilter@lists.netfilter.org"
     <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: yooman@fnet.pl
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 27 Apr 2004, Mike Andersen wrote:

> I reconfigured my test setup and used the FW for filtering instead of
mirroring (physical reconfiguration, all software .  Then the rules works as
intended.

Good.

> So the problem I'm having here, seems to be related to the mirroring. My gut
feeling says that it may be related to the fact that the state table is
being built independently of the netfilter rules.

netfilter conntrack requires traffic to be successfully forwarded to operate
correctly. If you drop traffic then netfilter assumes that packet was dropped
and never forwarded.

If you are mirroring then you must never drop or reject any packets as this
will disturb the connection tracking, but you can make whatever other
decisions on the packets you like.


> Here is some more data. First the rules used in this test case:
>
> iptables -A FORWARD -m conntrack --ctorigdst 10.10.10.199/32 -j LOG
--log-level  DEBUG --log-prefix '>ctorigdst> '
> iptables -A FORWARD -m conntrack --ctorigdst 10.10.10.199/32 -j ACCEPT
iptables -A FORWARD -j LOG --log-level DEBUG --log-prefix '>drop> ' iptables
-A FORWARD -j DROP
>
> Then I try to connect _from_ 10.10.10.199, and this is what the log says:
>
> Apr 27 14:22:35 local kernel: >drop> IN=br0 OUT=br0 PHYSIN=eth0
> PHYSOUT=eth1 SRC=10.10.10.199 DST=10.10.10.200 LEN=60 TOS=0x00
> PREC=0x00 TTL=64 ID=19660 DF PROTO=TCP SPT=51905 DPT=80 WINDOW=65535
RES=0x00 SYN URGP=0

This will also stop netfilter from setting up the connection tracking of this
session.

> Apr 27 14:22:35 local kernel: >ctorigdst> IN=br0 OUT=br0 PHYSIN=eth0
PHYSOUT=eth1 SRC=10.10.10.200 DST=10.10.10.199 LEN=60 TOS=0x00
> PREC=0x00 TTL=61 ID=0 DF PROTO=TCP SPT=80 DPT=51905 WINDOW=5792
> RES=0x00 ACK SYN URGP=0

This is then counted as the first packet of the session, and connection
tracking starts with 10.10.10.199 as the original destination (first packet
seen while tracking the session).

for TCP you can look for SYN to "work around" this and only accept NEW SYN,
not other NEW packets.

UDP is trickier as there is no connection control..

Regards
Henrik
