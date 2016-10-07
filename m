From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH nf-next 0/2] netfilter: autoload NAT support for
 non-builtin L4 protocols
Date: Fri, 7 Oct 2016 09:35:47 +0200
Message-ID: <CAOkSjBiQ0p+jP8tEq78Fighdhj34uoaLvTvn205ZsN8btmNJqg@mail.gmail.com>
References: <cover.1475773632.git.dcaratti@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org
To: Davide Caratti <dcaratti@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34548 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751174AbcJGHgJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Oct 2016 03:36:09 -0400
Received: by mail-wm0-f65.google.com with SMTP id b201so1568754wmb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Oct 2016 00:36:08 -0700 (PDT)
In-Reply-To: <cover.1475773632.git.dcaratti@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 6 October 2016 at 19:09, Davide Caratti <dcaratti@redhat.com> wrote:
> this series fixes SNAT/DNAT rules where port number translation is
> explicitly configured, but only the L3 address is translated:
>
> # iptables -t nat -A POSTROUTING -o eth1 -p stcp -j SNAT --to-source 10.0=
.0.1:61000
> # tcpdump -s46 -tni eth1 sctp
> tcpdump: verbose output suppressed, use -v or -vv for full protocol decod=
e
> listening on eth1, link-type EN10MB (Ethernet), capture size 46 bytes
> IP 10.0.0.1.37788 > 10.0.0.2.2000: sctp
>             ^^^^^
> IP 10.0.0.2.2000 > 10.0.0.1.37788: sctp
> IP 10.0.0.1.37788 > 10.0.0.2.2000: sctp
> IP 10.0.0.2.2000 > 10.0.0.1.37788: sctp
> IP 10.0.0.2.2000 > 10.0.0.1.37788: sctp
> IP 10.0.0.1.37788 > 10.0.0.2.2000: sctp
> IP 10.0.0.2.2000 > 10.0.0.1.37788: sctp
>
> This happens for all protocols that don't have L4 NAT support built into
> nf_nat.ko, such as DCCP, SCTP and UDPLite: unless the user modprobes
> nf_nat_proto_{dccp,sctp,udplite}.ko, port translation as specified in the
> above rule will not be done.
> The first patch provides persistent and generic aliases for the above
> modules; the second patch autoloads nf_nat_proto_{dccp,sctp,udplite} when=
 a
> SNAT/DNAT rule matching one of the above protocols is created.
>

Since I can add the same rule in nftables, I wonder if the same problem hap=
pens:

chain postrouting {
  type nat hook postrouting priority 0; policy accept;
  ip protocol sctp snat 10.0.0.1:61000
}

--=20
Arturo Borrero Gonz=C3=A1lez
