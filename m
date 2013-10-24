From: =?UTF-8?B?UGVra2EgUGlldGlrw6RpbmVu?= <pp@ee.oulu.fi>
Subject: Re: netfilter: xt_socket: add XT_SOCKET_NOWILDCARD flag causes behavioural
 change in userspace?
Date: Thu, 24 Oct 2013 14:21:53 +0300
Message-ID: <526902D1.50803@ee.oulu.fi>
References: <52667EBC.5010709@ee.oulu.fi> <20131024095212.GA4422@localhost> <1382609706.7572.48.camel@edumazet-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: edumazet@google.com, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ee.oulu.fi ([130.231.61.23]:49704 "EHLO ee.oulu.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab3JXLWF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Oct 2013 07:22:05 -0400
In-Reply-To: <1382609706.7572.48.camel@edumazet-glaptop.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24/10/13 13:15, Eric Dumazet wrote:
> On Thu, 2013-10-24 at 11:52 +0200, Pablo Neira Ayuso wrote:
>> Hi Pekka,
>>
>> On Tue, Oct 22, 2013 at 04:33:48PM +0300, Pekka Pietik=C3=A4inen wro=
te:
>>> After a kernel update to 3.11 (feat. commit
>>> 681f130f39e10087475383e6771b9366e26bab0c) my "generate fake tcp
>>> connections from random ip addresses" app broke.
>> Did you give a try to revert it and things were working back fine? I
>> think the root cause for this behaviour change is not in that patch.
> Yes, given that the option is off by default, I do not really underst=
and
> the issue.
>
> Its true that the option is currently a bit flawed, but my refactorin=
g
> of TCP listener should solve the problem soon. I do not feel necessar=
y
> to 'fix' xt_socket --nowildcard right now.
>
Okie, did some poking,  Going to before "use IP early demux" seems to=20
have found the real cause:

Old:

[ 1700.684685] sk->sk_state: 2
[ 1700.684688] wildcard: 0 transparent: 1, sk !=3D skb->sk 1
[ 1700.684691] proto 6 192.168.122.93:22 -> 5.5.5.5:45856 (orig=20
5.5.5.5:45856) sock ffff8803fb7b1500
[ 1700.685583] sk->sk_state: 4
[ 1700.685585] wildcard: 0 transparent: 1, sk !=3D skb->sk 1
[ 1700.685587] proto 6 192.168.122.93:22 -> 5.5.5.5:45856 (orig=20
5.5.5.5:45856) sock ffff8803fb7b1500
[ 1700.688443] sk->sk_state: 6
[ 1700.688445] wildcard: 0 transparent: 1, sk !=3D skb->sk 1

New:

[ 1613.960054] sk->sk_state: 7
[ 1613.960057] wildcard: 1 transparent: 1, sk !=3D skb->sk 0
[ 1613.960060] proto 6 192.168.122.93:22 -> 5.5.5.5:43540 (orig=20
5.5.5.5:43540) sock           (null)
[ 1615.511751] sk->sk_state: 7
[ 1615.511754] wildcard: 1 transparent: 1, sk !=3D skb->sk 0
[ 1615.511756] proto 6 192.168.122.93:22 -> 5.5.5.5:43540 (orig=20
5.5.5.5:43540) sock           (null)
[ 1615.963020] sk->sk_state: 7
[ 1615.963022] wildcard: 1 transparent: 1, sk !=3D skb->sk 0
[ 1615.963024] proto 6 192.168.122.93:22 -> 5.5.5.5:34950 (orig=20
5.5.5.5:34950) sock           (null)
[ 1615.963036] sk->sk_state: 7
[ 1615.963037] wildcard: 1 transparent: 1, sk !=3D skb->sk 0
[ 1615.963038] proto 6 192.168.122.93:22 -> 5.5.5.5:43540 (orig=20
5.5.5.5:43540) sock           (null)

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
