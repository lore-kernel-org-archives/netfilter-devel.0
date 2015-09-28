From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH next 0/5] netfilter: Pass net into ip_route_me_harder
Date: Mon, 28 Sep 2015 09:29:04 +0200
Message-ID: <5608EC40.4060207@6wind.com>
References: <87mvwn18my.fsf@x220.int.ebiederm.org>
 <87pp1fpy1b.fsf@x220.int.ebiederm.org>
 <87fv2bo7br.fsf_-_@x220.int.ebiederm.org>
 <87si62gteh.fsf_-_@x220.int.ebiederm.org>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	David Miller <davem@davemloft.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35727 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbbI1H3I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Sep 2015 03:29:08 -0400
Received: by wicge5 with SMTP id ge5so91622775wic.0
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2015 00:29:06 -0700 (PDT)
In-Reply-To: <87si62gteh.fsf_-_@x220.int.ebiederm.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 25/09/2015 22:01, Eric W. Biederman a =C3=A9crit :
>
> This is the next installment of my work to pass struct net through th=
e
> output path so the code does not need to guess how to figure out whic=
h
> network namespace it is in, and ultimately routes can have output
> devices in another network namespace.
>
> This round the focus is our getting struct net passed in, instead of
> guess in the netfilter functions that reroute packets
> (ip_route_me_harder, and ip6_route_me_harder).  There is a bit more w=
ork
> on the ipv4 side as the ipv6 code on several of these code paths alre=
ady
> passes in the struct net.
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
