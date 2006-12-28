From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: What should we do with packets marked as INVALID?
Date: Thu, 28 Dec 2006 11:06:41 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0612281032430.32322@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0612250059460.27316@bizon.gios.gov.pl>
	<45932B6F.3040802@netfilter.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-137719446-1167300401=:32322"
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <45932B6F.3040802@netfilter.org>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-137719446-1167300401=:32322
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 28 Dec 2006, Pablo Neira Ayuso wrote:

> Krzysztof Oledzki wrote:
>> One of the most important feature provided by the netfilter subsystem is
>> stateful connection tracking - the ability to decide that a packet is
>> valid (or not) using not only data from a packet itself but also from a
>> history of a flaw.
>>
>> So, the question is: what should we do with packets marked as INVALID?
>>
>> [...]
>>
>> So OK, REJECT is wrong (possibly kills valid connections), DROP (makes
>> invalid connections hang "forever") is also wrong, so maybe we should
>> forward such packets and allow dst hosts to handle it
>> (ignore/reset/etc). Bzzzz... no, wait, it is also wrong as we lose one
>> of the most important netfilter feature.
>
> IMO, the default action should be drop. Having a look at the errors in
> the tcp window tracking code, I can't think about a sane connection that
> can generate invalid out of window packets even under packet lost.

I agree to DROP it, especially that ~11Mbit/s communication betwen two of=
=20
my hosts (FreeBSD 6) is able to ganarate the "ip_ct_tcp: ACK is under the=
=20
lower bound" condition in about 1-2 minutes. One has 100Mbit NIC, the=20
second 1Gbit NIC and there is a linux FW between them. But I also want to=
=20
REJECT packets from unknown connections (no touple).

>> So, I have two propositions:
>>  - Add another state (ex. UNCLEAN) for packet that matches
>> proto/src/dst/sport/dport, but netfilter consider that it is wrong.
>
> If you let the invalid packet go through just because there is a tuple
> in the conntrack table that matches it then, why do you want the whole
> TCP window tracking?

I want to:
  - REJECT packets without a touple, to kill unknown connections.
  - DROP packets with a touple when window tracking decides that a packet=
=20
is invalid

I think it is quite sane...

> Just disabled it via ip_conntrack_tcp_be_liberal if
> you want to do so, out of window packets will not be marked as invalid,
> and you can still drop unclean packets since they are marked as invalid.

It does not solve anything, AFAIK setting ip_conntrack_tcp_be_liberal=20
ignores such packets but I want them to be dropped. :|

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-137719446-1167300401=:32322--
