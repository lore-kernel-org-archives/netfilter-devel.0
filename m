From: Davide Caratti <dcaratti@redhat.com>
Subject: Re: [PATCH nf-next 0/2] netfilter: autoload NAT support for
 non-builtin L4 protocols
Date: Fri, 07 Oct 2016 11:59:29 +0200
Message-ID: <1475834369.3103.14.camel@redhat.com>
References: <cover.1475773632.git.dcaratti@redhat.com>
         <CAOkSjBiQ0p+jP8tEq78Fighdhj34uoaLvTvn205ZsN8btmNJqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48692 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751222AbcJGKAA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Oct 2016 06:00:00 -0400
In-Reply-To: <CAOkSjBiQ0p+jP8tEq78Fighdhj34uoaLvTvn205ZsN8btmNJqg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2016-10-07 at 09:35 +0200, Arturo Borrero Gonzalez wrote:
> Since I can add the same rule in nftables, I wonder if the same problem
> happens:
> 
> chain postrouting {
>   type nat hook postrouting priority 0; policy accept;
>   ip protocol sctp snat 10.0.0.1:61000
> }
> 

hello Arturo,

thank you for looking at this. I just did a test following your suggestion:

# iptables -F -t nat
# rmmod nf_nat_proto_sctp
# nft add table nat
# nft add chain nat prerouting { type nat hook prerouting priority 1 \; }
# nft add chain nat postrouting { type nat hook postrouting priority 0 \; }
# nft add rule nat postrouting oif eth1 ip protocol sctp snat 10.0.0.1:61000
# IP 10.0.0.1.55836 > 10.0.0.2.2000: sctp
IP 10.0.0.2.2000 > 10.0.0.1.55836: sctp
IP 10.0.0.1.55836 > 10.0.0.2.2000: sctp
IP 10.0.0.2.2000 > 10.0.0.1.55836: sctp
IP 10.0.0.1.55836 > 10.0.0.2.2000: sctp
IP 10.0.0.2.2000 > 10.0.0.1.55836: sctp
IP 10.0.0.1.55836 > 10.0.0.2.2000: sctp
IP 10.0.0.2.2000 > 10.0.0.1.55836: sctp
IP 10.0.0.1.55836 > 10.0.0.2.2000: sctp
# modprobe nf_nat_proto_sctp
# IP 10.0.0.1.61000 > 10.0.0.2.2000: sctp
IP 10.0.0.2.2000 > 10.0.0.1.61000: sctp
IP 10.0.0.1.61000 > 10.0.0.2.2000: sctp
IP 10.0.0.2.2000 > 10.0.0.1.61000: sctp
IP 10.0.0.1.61000 > 10.0.0.2.2000: sctp
IP 10.0.0.2.2000 > 10.0.0.1.61000: sctp
IP 10.0.0.1.61000 > 10.0.0.2.2000: sctp
IP 10.0.0.2.2000 > 10.0.0.1.61000: sctp
IP 10.0.0.1.61000 > 10.0.0.2.2000: sctp
#

you are right, unless you manually modprobe nf_nat_proto_sctp.ko, you will
see wrong port translation also with nftables, and this patch does not fix
it. Then I will submit a v2 that also handles nftables.

regards,
--
davide
