From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: [RESEND][PATCH] Hop Limit match/target for IPv6
Date: Thu, 2 Jan 2003 12:05:01 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0301021150160.31237-100000@dns.toxicfilms.tv>
References: <1041434217.930.14.camel@arwen.middleearth.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andras Kis-Szabo <kisza@securityaudit.hu>
In-Reply-To: <1041434217.930.14.camel@arwen.middleearth.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> BCF the end of the year I have not got enough time to test your m/t (and
> drop a mail to Harald). :( (But it looks like a working module.:))
Well, i tested it with 2 ipv6 enabled linux hosts. with rules:

dns:~# ip6tables -A INPUT -m hl --hl-lt 255 -j LOG
dns:~# ip6tables -A INPUT -t mangle -j HL --hl-set 5

then i pinged the host from other host, and watched the logs:
IN=eth1 OUT= MAC=00:50:da:41:eb:18:00:50:da:41:ea:e4:86:dd
SRC=3ffe:8320:0002:0018:0000:0000:0000:0001
DST=3ffe:8320:0002:0018:0000:0000:0000:0057
LEN=104 TC=0 HOPLIMIT=5 FLOWLBL=0 PROTO=ICMPv6 TYPE=128 CODE=0 ID=64361
SEQ=256

Success, we managed to mangle the HopLimit with the target, and to log it
using the match.

> Personally, I have got some problems related the hoplimit target. W/o
> IPSec it can be very dangerous in IPv6 networks.
Well, I am an IPv6 begginer with no IPSec experience.

> (If the auto configuration is enabled.)
> But the other hand with this target we can hide the firewall and check the
> validity of the management messages.
The kernel (2.4.20) said:
ICMP NDISC: fake message with non-255 Hop Limit received: 5

One question though, when i was just starting up with ipv6 i used to
tcpdump the ipv6 traffic, and found a peculiar thing.
I was pinging an ipv6 host in other country (5 ipv6 hops) and before i got
a icmp echo reply i used to get 3 ip6 neighbor discoveries.
These icmps of course went through the 5 hops and their HopLimit was 250,
The kernel said it's a fake message because it does not have HL of 255.
Then i read the RFC on it, and from what i understand, these neighbor
discoveries should not come through other networks, should not be routed.
Of course i may be wrong, what do you think ?

Regards,
Maciej Soltysiak
