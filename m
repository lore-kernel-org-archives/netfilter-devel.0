From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH] tests/shell: add chain validations tests
Date: Wed, 23 Mar 2016 08:44:31 +0100
Message-ID: <CAOkSjBimNsBCYTK3AnHc4iFUkkjGoDU+y7Hn1j+qEfjHLPSR4A@mail.gmail.com>
References: <145865193086.6118.9200431804176858644.stgit@nfdev2.cica.es> <20160322192019.GA7551@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:38204 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbcCWHow convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Mar 2016 03:44:52 -0400
Received: by mail-wm0-f43.google.com with SMTP id l68so11818521wml.1
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Mar 2016 00:44:52 -0700 (PDT)
In-Reply-To: <20160322192019.GA7551@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 22 March 2016 at 20:20, Pablo Neira Ayuso <pablo@netfilter.org> wrot=
e:
> On Tue, Mar 22, 2016 at 02:06:09PM +0100, Arturo Borrero Gonzalez wro=
te:
>> Some basic test regarding chains: jumps and validations.
>>
>> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.co=
m>
>> ---
>> NOTE: the testcases/chains/0009masquerade_jump_1 file fails, seems l=
ike a bug
>> in the kernel validation. Needs more investigation.
>
> I can see this there:
>
>> +$NFT add chain t output {type nat hook output priority 0 \; }
>
> We only support masquerade from postrouting.
>
> static struct xt_target masquerade_tg_reg __read_mostly =3D {
>         .name           =3D "MASQUERADE",
>         .family         =3D NFPROTO_IPV4,
>         .target         =3D masquerade_tg,
>         .targetsize     =3D sizeof(struct nf_nat_ipv4_multi_range_com=
pat),
>         .table          =3D "nat",
>         .hooks          =3D 1 << NF_INET_POST_ROUTING,
>
> BTW, it would be good to add more tests to exercise the chain loop
> detection code.
>
> Please, fix and resubmit, thanks.

Probably mi description of the problem was poor.

The offending testcase is testing, in fact, that we can add a rule
with a jump to a chain with a masquerade rule, thus connecting
masquerade to a output hook:

$NFT add table t
$NFT add chain t output {type nat hook output priority 0 \; }
$NFT add chain t c1
$NFT add rule t c1 masquerade
$NFT add rule t output tcp dport vmap {1 :jump c1 }

this don't fail, and that's the problem indeed.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
