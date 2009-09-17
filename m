From: Fred Moyer <fred@redhotpenguin.com>
Subject: Re: [ANNOUNCE] new iptables module match large amount of ip addresses
Date: Thu, 17 Sep 2009 16:05:23 -0700
Message-ID: <ad28918e0909171605m67a899b9l6c37483cba79628f@mail.gmail.com>
References: <Pine.LNX.4.64.0909172100220.27299@artax.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f179.google.com ([209.85.222.179]:62058 "EHLO
	mail-pz0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbZIQXMQ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Sep 2009 19:12:16 -0400
Received: by pzk9 with SMTP id 9so153804pzk.33
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2009 16:12:20 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.64.0909172100220.27299@artax.karlin.mff.cuni.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 17, 2009 at 12:15 PM, Mikulas Patocka
<mikulas@artax.karlin.mff.cuni.cz> wrote:
> Hi
>
> Here I submit an iptables module that can match large amounts (millio=
ns)
> of ip addresses efficiently using binary search. I needed it to prote=
ct my
> home network from spam. It may be useful for other people too, so if =
you
> want it, you can take it and add it to the kernel.

I'm not familiar with xt_geoip or ipset, but from the first look at
this module I want to say thank you!  This is the perfect tool for a
problem I have been wanting to solve for a while.



>
> Get the patches for netfilter and kernel at:
> http://artax.karlin.mff.cuni.cz/~mikulas/xt_ipfile/
> (you need to copy the file include/linux/netfilter/xt_ipfile.h from k=
ernel
> sources to /usr/include/linux/netfilter/ to compile the userspace)
>
> The main features:
> - fast matching of large amount of ip addresses using binary search.
> - an ability to match ranges of addresses or address/mask subnets.
> - fast loading of the addresses (on Pentium 3 850, 2 million addresse=
s
> load in 5.5s, if they are already sorted in the file, the load time i=
s
> just 1.5s).
> - memory efficient --- consumes only 8 bytes per address.
>
> USAGE:
>
> prepare a file with addreses, in this example /root/firewall/bad-ips.=
 One
> entry per line, the allowed formats are:
> 1.2.3.4
> 1.2.3.0/24
> 1.2.3.4-1.2.3.8
>
> insert it into iptables with:
> iptables -A SPAM -m ipfile --src-file /root/firewall/bad-ips -j DROP
>
> The module doesn't support ipv6 because I don't use it, but it's gene=
ric
> enough that it could be extended for it. It could be also extended to
> match ethernet MAC addresses.
>
> Mikulas
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
