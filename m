From: "Mike Andersen" <mike@src.no>
Subject: Re: Idea: Check session source and destination
Date: Sun, 23 May 2004 03:13:50 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1930.80.53.224.38.1085274830.squirrel@www.tmuras.2000.cd>
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

On Apr 26, 2004, at 16:44, Henrik Nordstrom wrote:

> On Mon, 26 Apr 2004, Mike Andersen wrote:
>
>> iptables -A FORWARD -m conntrack --ctorigdst <int_ip> -j ACCEPT iptables -A
FORWARD -j DROP
>
> Works here..
>
>> I then look more closely at the state table (/proc/net/ip_conntrack) and
see that there are two sets of source definition, and two sets for the
destination:
>
> One is the ORIGINAL direction, the other the REPLY direction. Each is
matched independently by the "conntrack" match (--ctorigdst vs
> --ctreplydst).

Ah, that explains it.  Thanks for clearing up that.

>> Any idea of why the "-m conntrack --ctorigdst <int_ip>" also passes through
traffic where int_ip is the source of the session?
>
> Does work like intended here and only matches where it is the original
destination. But I am using this for packet filtering, not mirroring. Not
that I see any difference.

I reconfigured my test setup and used the FW for filtering instead of
mirroring (physical reconfiguration, all software .  Then the rules works as
intended.

So the problem I'm having here, seems to be related to the mirroring. My gut
feeling says that it may be related to the fact that the state table is being
built independently of the netfilter rules.

Here is some more data. First the rules used in this test case:

iptables -A FORWARD -m conntrack --ctorigdst 10.10.10.199/32 -j LOG
--log-level  DEBUG --log-prefix '>ctorigdst> '
iptables -A FORWARD -m conntrack --ctorigdst 10.10.10.199/32 -j ACCEPT
iptables -A FORWARD -j LOG --log-level DEBUG --log-prefix '>drop> ' iptables
-A FORWARD -j DROP

Then I try to connect _from_ 10.10.10.199, and this is what the log says:

Apr 27 14:22:35 local kernel: >drop> IN=br0 OUT=br0 PHYSIN=eth0
PHYSOUT=eth1 SRC=10.10.10.199 DST=10.10.10.200 LEN=60 TOS=0x00
PREC=0x00 TTL=64 ID=19660 DF PROTO=TCP SPT=51905 DPT=80 WINDOW=65535 RES=0x00
SYN URGP=0

Apr 27 14:22:35 local kernel: >ctorigdst> IN=br0 OUT=br0 PHYSIN=eth0
PHYSOUT=eth1 SRC=10.10.10.200 DST=10.10.10.199 LEN=60 TOS=0x00
PREC=0x00 TTL=61 ID=0 DF PROTO=TCP SPT=80 DPT=51905 WINDOW=5792
RES=0x00 ACK SYN URGP=0

Apr 27 14:22:35 local kernel: >ctorigdst> IN=br0 OUT=br0 PHYSIN=eth0
PHYSOUT=eth1 SRC=10.10.10.199 DST=10.10.10.200 LEN=52 TOS=0x00
PREC=0x00 TTL=64 ID=19661 DF PROTO=TCP SPT=51905 DPT=80 WINDOW=65535 RES=0x00
ACK URGP=0

Apr 27 14:22:35 local kernel: >ctorigdst> IN=br0 OUT=br0 PHYSIN=eth0
PHYSOUT=eth1 SRC=10.10.10.199 DST=10.10.10.200 LEN=536 TOS=0x00
PREC=0x00 TTL=64 ID=19662 DF PROTO=TCP SPT=51905 DPT=80 WINDOW=65535 RES=0x00
ACK PSH URGP=0

Apr 27 14:22:36 local kernel: >ctorigdst> IN=br0 OUT=br0 PHYSIN=eth0
PHYSOUT=eth1 SRC=10.10.10.200 DST=10.10.10.199 LEN=52 TOS=0x00
PREC=0x00 TTL=61 ID=58220 DF PROTO=TCP SPT=80 DPT=51905 WINDOW=6432 RES=0x00
ACK URGP=0

As you see, the first SYN package is dropped, while the rest of the traffic is
passed through.

I really want to figure out _why_ this is not working as intended, and are
therefore willing to put a lot of hours into testing.  But I'm pretty stuck
here.  Any suggestion and hints about what I should try out next
(tools/configurations etc) is very welcome.

mike
--
"It is a lesson which all history teaches wise men, to put trust in
  ideas, and not in circumstances."            --Ralph Waldo Emerson
