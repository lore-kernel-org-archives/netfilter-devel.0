From: Jens Hektor <hektor@rz.rwth-aachen.de>
Subject: Re: [netfilter-core] netfilter violates RFC 1812
Date: Thu, 05 Dec 2002 08:34:14 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DEF0176.3020208@rz.rwth-aachen.de>
References: <20021204130651.GF9736@naboo.club.berlin.ccc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Wolfgang Kueter <wolfgang@shconnect.de>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-reply-to: <20021204130651.GF9736@naboo.club.berlin.ccc.de>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:
> Yup, please refer to multiple threads about this subject on
> netfilter-devel.

Should have have looked a bit earlier into this list (before
developing my own patch).

>>RFC 1812 (pp81-82) clearly states that router with packet filtering
>>capabilities should give ICMP Type "destination unreachable", code
>>"communication administratively prohibited" (13).
> 
> this is true.  There are patches floating around for exactly this
> issue.  The problem is: It is impossible to add this feature without
> hurting backwards- or forward-compatibility between new/old
> iptables-userspace and iptables-kernel.  So we're sort of in a no-win
> situation :(

I already submitted a bit more elaborated patch to the netfilter-devel.

The situation as I see it could be described as such:

we have five groups of people involved:

a) the netfilter team
b) the distro makers taking more or less actual software what a) give them
c) the mainstream users, mostly using what b) gives them
d) geeks, the compile actual kernels & iptables for themselves
e) others with non-linux OS's

W. Kueter and I started a discussion about e) and whether their
machines (OSs) honor rejecting of pakets. Thereby we discovered
this flaw in Linux.

I think it would be a good idea to say that there is a new version
of kernel as well as iptables which fixes it and can be used only
together. Anyone who wants something else should stick to older versions
or patch his kernel/iptables by his own.

I think  that a)-d) can live with that.

Compatibility is fine but RFC compliance is preferred by me having setup
several dozends of linux based paketfilters around here. We should not
live with bugs too long and for me it's a bug

-- 
Jens Hektor, RWTH Aachen, Rechenzentrum, Seffenter Weg 23, 52074 Aachen
Computing Center, Aachen University, network operation & security
mailto:hektor@RZ.RWTH-Aachen.DE, Tel.: +49 241 80 29206, Raum: 2.35
