From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: What should we do with packets marked as INVALID?
Date: Thu, 28 Dec 2006 17:25:22 +0100
Message-ID: <4593EFF2.1090400@netfilter.org>
References: <Pine.LNX.4.64.0612250059460.27316@bizon.gios.gov.pl>
	<45932B6F.3040802@netfilter.org>
	<Pine.LNX.4.64.0612281032430.32322@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <ole@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0612281032430.32322@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> On Thu, 28 Dec 2006, Pablo Neira Ayuso wrote:
>> Krzysztof Oledzki wrote:
>>> So, the question is: what should we do with packets marked as INVALID?
>>>
>>> [...]
>>>
>>> So OK, REJECT is wrong (possibly kills valid connections), DROP (makes
>>> invalid connections hang "forever") is also wrong, so maybe we should
>>> forward such packets and allow dst hosts to handle it
>>> (ignore/reset/etc). Bzzzz... no, wait, it is also wrong as we lose one
>>> of the most important netfilter feature.
>>
>> IMO, the default action should be drop. Having a look at the errors in
>> the tcp window tracking code, I can't think about a sane connection that
>> can generate invalid out of window packets even under packet lost.
> 
> I agree to DROP it, especially that ~11Mbit/s communication betwen two
> of my hosts (FreeBSD 6) is able to ganarate the "ip_ct_tcp: ACK is under
> the lower bound" condition in about 1-2 minutes. One has 100Mbit NIC,
> the second 1Gbit NIC and there is a linux FW between them. But I also
> want to REJECT packets from unknown connections (no touple).

All packets have a conntrack, and therefore a tuple. Even those that
don't belong to a unexistent connection. The point is if the
conntrack is confirmed or not, ie. at least one packet of a certain
connection traversed the stack successfully. The TCP window tracking
does not mark as invalid unconfirmed conntracks, just checks if the
packets follows an appropiate protocol sequence, ie. a packet with the
flag push set for an "unknown" connection is invalid.

> I want to:
>  - REJECT packets without a touple, to kill unknown connections.
>  - DROP packets with a touple when window tracking decides that a packet
> is invalid
> 
> I think it is quite sane...

iptables -P FORWARD -j DROP
[... your ruleset ...]
iptables -A FORWARD -m state INVALID -j LOG --log-prefix "invalid: "
iptables -A FORWARD -m state INVALID -j DROP
iptables -A FORWARD -p tcp --syn -j REJECT --reject-with tcp-reset

Couldn't this be enough? In this case, an invalid packet is always
dropped, and a valid packet, a TCP syn packet for a filtered port, is
replied with a TCP reset. Of course, as I told you before, a packet with
a wrong flag combination for an unknown connection is marked as invalid
by the TCP tracking code, but this is the expected behaviour.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
