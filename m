From: Konstantin Ushakov <kostik@oktetlabs.ru>
Subject: Re: [netfilter-core] Mangle table rules are not taken into account
 in preliminary routing decision
Date: Mon, 15 Oct 2007 18:11:41 +0400
Message-ID: <4713751D.6080309@oktetlabs.ru>
References: <470CA4DF.6000803@oktetlabs.ru> <470DA22F.70807@trash.net> <470DC711.4020701@oktetlabs.ru> <470DCEFF.6030709@trash.net> <470DE946.9090301@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shelob-wplus.oktetlabs.ru ([195.131.132.186]:51169 "EHLO
	shelob.oktetlabs.ru" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755175AbXJOOLu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Oct 2007 10:11:50 -0400
In-Reply-To: <470DE946.9090301@plouf.fr.eu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Pascal Hambourg wrote:
> Hello,
>
> Patrick McHardy a =E9crit :
>>
>> Ah, I see the problem. The route returns unreachable, which
>> iptable_mangle translates to NF_DROP. The problem is that
>> netfilter itself can't return ENETUNREACH and there is no
>> valid output function attached to the dst_entry that would
>> send an icmp unreachable. I think the only thing you could
>> do is manually call icmp_send(ICMP_DEST_UNREACH) in
>> ip_route_me_harder for this case.
>
> What about the REJECT target ?
Correct me if I'm mistaken, but REJECT target is only valid in filter
table. But the
packet does not reach filter table because of reasons described by
Patric (as we DROP
it after mangle). It is clearly observed by me when I insert LOG into
filter table.
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
