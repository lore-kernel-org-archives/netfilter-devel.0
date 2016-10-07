From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH nf-next 0/2] netfilter: autoload NAT support for
 non-builtin L4 protocols
Date: Fri, 7 Oct 2016 12:32:25 +0200
Message-ID: <CAOkSjBi8zZCyZ-7pqpiboK5HcnTohtx0vscA73wjHNzH-r5FHw@mail.gmail.com>
References: <cover.1475773632.git.dcaratti@redhat.com> <CAOkSjBiQ0p+jP8tEq78Fighdhj34uoaLvTvn205ZsN8btmNJqg@mail.gmail.com>
 <1475834369.3103.14.camel@redhat.com>
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
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35775 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752564AbcJGKoF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Oct 2016 06:44:05 -0400
Received: by mail-wm0-f65.google.com with SMTP id f193so2321832wmg.2
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Oct 2016 03:44:05 -0700 (PDT)
In-Reply-To: <1475834369.3103.14.camel@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 7 October 2016 at 11:59, Davide Caratti <dcaratti@redhat.com> wrote:
> On Fri, 2016-10-07 at 09:35 +0200, Arturo Borrero Gonzalez wrote:
>> Since I can add the same rule in nftables, I wonder if the same problem
>> happens:
>>
>> chain postrouting {
>>   type nat hook postrouting priority 0; policy accept;
>>   ip protocol sctp snat 10.0.0.1:61000
>> }
>>
>
> hello Arturo,
>
> thank you for looking at this. I just did a test following your suggestio=
n:
>
> # iptables -F -t nat
> # rmmod nf_nat_proto_sctp
> # nft add table nat
> # nft add chain nat prerouting { type nat hook prerouting priority 1 \; }
> # nft add chain nat postrouting { type nat hook postrouting priority 0 \;=
 }
> # nft add rule nat postrouting oif eth1 ip protocol sctp snat 10.0.0.1:61=
000
> # IP 10.0.0.1.55836 > 10.0.0.2.2000: sctp
> IP 10.0.0.2.2000 > 10.0.0.1.55836: sctp
> IP 10.0.0.1.55836 > 10.0.0.2.2000: sctp
> IP 10.0.0.2.2000 > 10.0.0.1.55836: sctp
> IP 10.0.0.1.55836 > 10.0.0.2.2000: sctp
> IP 10.0.0.2.2000 > 10.0.0.1.55836: sctp
> IP 10.0.0.1.55836 > 10.0.0.2.2000: sctp
> IP 10.0.0.2.2000 > 10.0.0.1.55836: sctp
> IP 10.0.0.1.55836 > 10.0.0.2.2000: sctp
> # modprobe nf_nat_proto_sctp
> # IP 10.0.0.1.61000 > 10.0.0.2.2000: sctp
> IP 10.0.0.2.2000 > 10.0.0.1.61000: sctp
> IP 10.0.0.1.61000 > 10.0.0.2.2000: sctp
> IP 10.0.0.2.2000 > 10.0.0.1.61000: sctp
> IP 10.0.0.1.61000 > 10.0.0.2.2000: sctp
> IP 10.0.0.2.2000 > 10.0.0.1.61000: sctp
> IP 10.0.0.1.61000 > 10.0.0.2.2000: sctp
> IP 10.0.0.2.2000 > 10.0.0.1.61000: sctp
> IP 10.0.0.1.61000 > 10.0.0.2.2000: sctp
> #
>
> you are right, unless you manually modprobe nf_nat_proto_sctp.ko, you wil=
l
> see wrong port translation also with nftables, and this patch does not fi=
x
> it. Then I will submit a v2 that also handles nftables.
>

Thanks Davide for your work and time.

Unlike in iptables, in nftables we don't know the expected l4 protocol
at rule setup time.

In the iptables<->nftables compat layer, we have an expression
attribute which is filled from userspace with the l4 protocol
(NFTA_RULE_COMPAT_PROTO).

Not sure if it's worth adding a new netlink attribute for nft_nat to
tell the expression about the expected l4 NAT protocol.
--=20
Arturo Borrero Gonz=C3=A1lez
