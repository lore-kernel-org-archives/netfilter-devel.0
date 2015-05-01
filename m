From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Matching MLD with ip6tables
Date: Fri, 1 May 2015 08:33:03 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1505010828090.30665@nerf40.vanv.qr>
References: <20150501025612.GB2465@odroid>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Linus_L=C3=BCssing?= <linus.luessing@c0d3.blue>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:54104 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbbEAGdF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 May 2015 02:33:05 -0400
In-Reply-To: <20150501025612.GB2465@odroid>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2015-05-01 04:56, Linus L=C3=BCssing wrote:
>
>According to RFC4890 ("Recommendations for Filtering ICMPv6
>Messages in Firewalls"), page 35, a rule like this should match
>MLD packets:
>
>$ ip6tables -A icmpv6-filter -p icmpv6 --icmpv6-type {130,131,132,143}=
 ...
>
>However, this does not seem to work for me. My guess is that it
>does not match because --protocol is not 'icmpv6' but actually
>the hop-by-hop-option first.
>Also, is there a way to somehow match IPv6 protocols with IPv6
>options in between?

-p matches the first non-extension header. For the
exthdrs, there is e.g. -m hbh.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
