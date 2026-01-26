Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4C21F19A
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Jan 2026 01:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769389391; cv=pass; b=aZz1+xVzaUWGR6KRxjct14KoGBs1vp1Hbp/7FgSRkfMkAcdPXcX02NnmuPWOaKHEq0ZcuiWeE5ZEFavv61ywx1b/7aGtnlnzOyBTq8o68JlP7ZQKOUjqayyevCCawbwrHH0JtJCZI/Fys9oLk7MU2LGQ1oY+6GaXl/pMjJVuJFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769389391; c=relaxed/simple;
	bh=Q7dIhwEOVfuWdFl+M+JKTEMOciUl1YNkF4KjwnuRpa8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iX3jo+T+09BOvbSo4ykmCaUnaHFVZxFv34vON3jLnLs9yax96AN9VCdD0vDAOUe0tg6rmQqOInstiBHAe0yAGLgCRaWjiq447KxcXBRzaDRCAPzsbsIKXhkFe5kB1L2jnpUEM+yaNMvInR2OUx7DBn5IbiMzu8H9/VWMCB3I3gI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UNDeKXxM; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=s2hR0QjE; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UNDeKXxM";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="s2hR0QjE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769389388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yq9iklkmQGvR2jV12m4/qhYdwWeuHImbvKI3wqeNYOE=;
	b=UNDeKXxM/iNC5nCKxfktE2v0u+UeELMTad2UiPJ5V+XNNKFTJ5/ADMLvGv2PHoq/5Laggo
	9Q+U06gUFlWQUQdAqbCxGGUyZBPi8GyL3ctqkx2e9tBIxdopDO3mxAOfIdw1MFLSkMPotf
	Dn7QIYYR3PC+H0pshEKHep7Y/ATa5/U=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-552-mLX60-aXMOub4mvYE08wKg-1; Sun, 25 Jan 2026 20:03:07 -0500
X-MC-Unique: mLX60-aXMOub4mvYE08wKg-1
X-Mimecast-MFC-AGG-ID: mLX60-aXMOub4mvYE08wKg_1769389386
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34c66cb671fso4007689a91.3
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Jan 2026 17:03:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769389386; cv=none;
        d=google.com; s=arc-20240605;
        b=bUniB5TtoCtXjed3OkOhQLaY9jjOzTH4mWnNvtZF94SXZKlaV+7wj81qaFXBoU77nL
         JbsqHb/CB1u4vEBGWg+iOk5HpOYXotRSnyZltB5LruBF6Lu1ap8UXDIqC+LW874AjL6x
         V6Rlqan//BEcmKp6qwTSjAs1FWTjC27Sjoei4IuU+R4+HW3fiJFCVwkrpJbT3Cot1sFI
         K/dgzF93YKyFjIIlvgjnzgYI9jXPHhHOY+ctIQYCtXaAM8pZQkYWt0PEUBlDFFR/9tDS
         O/4oPnbnnnC+jJgsfBKNiswX7doAN9sPLGCIJdHT2Y3ez464JjtJ2tTn5t6sY2cwr+1K
         hqmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yq9iklkmQGvR2jV12m4/qhYdwWeuHImbvKI3wqeNYOE=;
        fh=IPmxcMsW+hggd8nsTVcZY+5CFntyYFdiSPpAyy1M2nI=;
        b=OicDXjLEYwAKunEyWcf7PN1eI0Dhkr0Jb4blr2OrGCX8OWyIackX9wWRKNRIFnGeKl
         nL65JPUnXdv+m3XXcBhWCV37e9/KLiGhu/NSeYgh4F7tQicey0/pgANPntaywh3+cdJ8
         XRf9VBZ2kJYrsk82uSYj9ccTL9ncjxQebDwYuyWwtg3+dvpToRsYwlAR1NUZK9pXNr4e
         TllbEwSMx0LBUwwXEi4jvtsa/7bEvndavZ/7qhOz9nUvNSFeF1W+v7Mg4Z2lXyNQtP2k
         h+eOjNWK/aeVx8V/dfZD0NchA7H2ZJ90K7pmoRDDPAu9jZSmm8qsHgQwQbRNW63yzV+X
         lJpw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769389386; x=1769994186; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yq9iklkmQGvR2jV12m4/qhYdwWeuHImbvKI3wqeNYOE=;
        b=s2hR0QjEqBcxcQzRYT/hzvMPnl7GDhi2nBwDgOUN7umbqtOv2+C7vYM7O1Sa3pt0BV
         8al0H3YH/7eftiX5jkSGIdF0s03cfx65C9y/7nKZLYyUeqbdw811i10cavMcVCwJW0pj
         kFZMkKOzJaYhFYqYke3tGHyYdfcXAr0PgnAgIC/sOHbuNezN0JxdNZwx3cazUv8jWULW
         46In9yYYoi2TKIZt9Eu0aGhqSvnVQu6mqlMbGnHrGoPUiE7N6aOHJBTPlfhPGmsHZU0f
         7RXe99WeREty29Ss+GfIcdtHasJGeAv/x3ZWUZEjj1N0Jbw07UeJxvdfwHBDaEpuj7Ep
         W7Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769389386; x=1769994186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yq9iklkmQGvR2jV12m4/qhYdwWeuHImbvKI3wqeNYOE=;
        b=VJ8N1CPwQoFU+vJA81DadZpn4hKH0KWIrH8Uh9q3s+9/0vk7Egali72/idK+298qGu
         0i4BWGWVi9AxDVHTefKki9KyDG9t0eSiJsWGBI0Yo4Tvfchy80dsEMLR/PtlyG2O4fIV
         +RDoc0w6wpTpODNjTp819qdwONkfdHeqpVn5PtS80jAbAvhDB2oSBJwAYfXGu1UiS68L
         wlhCNSG2HKISk/+4Bx6fu7ootF/DoX6DKmhcAuU5NbdwEUrhQDAF2Yv7P5BOZbBtCQO2
         bp8F6pjfKDEgjVB9nciyatsaILPim4SAZBxlCF/JzksCscEfZKCqeoXrxGF8oHUbHqWV
         IFRQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqXtJy1VD5ZOGyEH18ZaTUYX5RTPNgkKpE7JZuKi7VkA4QjLG8y5phj4060L1KqVAIZ+S/d1eWjT0gF95RHeE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaBpestywSgWzTX79uKb7+HyHCjBcw6zeQoRducpLpefSxUgS6
	d6vkSfK2LWMlL5S1trX4lYMtjnmUjrDmREQ5PY2XjLlxlT+L7HvN9h7X0qPHu1KqFVbw5uSQuvz
	G7YuASVhA8ouBk9Tc2aby85WedQ8Lies4DBd9h3k9ILMSrlTm3jgnQX80HiUGAjot0URglcJtBY
	MOe2bx24IzB6wTEOTt6/3r/SJ6qluCyEkS8jWX1W5257TV
X-Gm-Gg: AZuq6aJw0bsD9jSEE72IRyJwAgKpfd5Mo5wKTeNVHs8tuxOffFetpbJt7Tz5hNsXOmq
	3r8Qz5pEVFDrZ3k1S1OfZ3TtevLnPH1P1mCOkn/50sHjkFfoRXRTtBsvl8Qy/z33qo2YsH3lvck
	4Ou+Fcg0RKfthJRYzYchyA2h3akMLTU1nmQaEoh2v+mzR2rui9Ko4ICHOiYUnCDvXfz4g=
X-Received: by 2002:a17:90b:2241:b0:330:7ff5:2c58 with SMTP id 98e67ed59e1d1-353c40bca24mr2570009a91.7.1769389385710;
        Sun, 25 Jan 2026 17:03:05 -0800 (PST)
X-Received: by 2002:a17:90b:2241:b0:330:7ff5:2c58 with SMTP id
 98e67ed59e1d1-353c40bca24mr2569967a91.7.1769389385120; Sun, 25 Jan 2026
 17:03:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821091302.9032-1-fmancera@suse.de> <20250821091302.9032-3-fmancera@suse.de>
 <CAJsUoE2uoZJH2VA6E+J+SK=G1W06JE2+0v-NmgGyGWBNRKFgng@mail.gmail.com>
 <0f9b3772-0b38-40ae-ad3f-e2e790695054@suse.de> <CAJsUoE24NEe65atDs58dgwgxir8vLtEbrRkKp0nXpUVHFD6E_g@mail.gmail.com>
In-Reply-To: <CAJsUoE24NEe65atDs58dgwgxir8vLtEbrRkKp0nXpUVHFD6E_g@mail.gmail.com>
From: Yi Chen <yiche@redhat.com>
Date: Mon, 26 Jan 2026 09:02:38 +0800
X-Gm-Features: AZwV_QjsRK2KaxWJ7zv1zdzHQ66Lr3zxgqXZ1B26k6aqB6A_5sp1DhnKe0G2xuU
Message-ID: <CAJsUoE1pVXYdRNOuiNvKcm51JkZnsXcsTmSkyddaXa3pyVJQRA@mail.gmail.com>
Subject: Re: [PATCH 3/7 nft v3] src: add tunnel statement and expression support
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de, 
	Phil Sutter <phil@nwl.cc>, Eric Garver <egarver@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Fernando,

Thanks for the detailed explanation, that helps a lot to understand
the intended design and the use case.
While going through the example ruleset, I didn't see how the initial
traffic initiation from VM A is supposed to work in practice,
and I would like to check whether I am missing something.

As far as I can see, all the rules are added to netdev ingress hooks
(both on veth_host and vxlan0),
but it is unclear to me how locally generated traffic is handled.
For example, when VM A actively sends traffic (e.g. ping 10.0.0.2),
the packets are outgoing and won't match in an ingress hook chain.
so they would not match the redirect_to_tunnel chain.

Related to this, I am also unsure how ARP is expected to work. Before
any ICMP packet can be sent, ARP resolution for 10.0.0.2 must happen,
but ARP packets would not match the ip daddr 10.0.0.2 rule either. and
won't be encapsulated.

Could you clarify how egress traffic and ARP/neighbor resolution are
expected to be handled in this way?
Thanks again, and sorry if I am missing something obvious.

Best regards,
Yi


On Fri, Jan 23, 2026 at 11:27=E2=80=AFPM Yi Chen <yiche@redhat.com> wrote:
>
> Hi Fernando,
>
> Thanks for the detailed explanation, that helps a lot to understand the i=
ntended design and the use case.
> While going through the example ruleset, I am still struggling to see how=
 the initial traffic initiation from VM A is supposed to work in practice,
> and I would like to check whether I am missing something.
>
> As far as I can see, all the rules are added to netdev ingress hooks (bot=
h on veth_host and vxlan0),
> but it is unclear to me how locally generated traffic is handled.
> For example, when VM A actively sends traffic (e.g. ping 10.0.0.2), the p=
ackets are outgoing and won't match in a ingress hook chain.
> so they would not match the redirect_to_tunnel chain.
>
> Related to this, I am also unsure how ARP is expected to work. Before any=
 ICMP packet can be sent, ARP resolution for 10.0.0.2 must happen,
> but ARP packets would not match the ip daddr 10.0.0.2 rule either. and wo=
n't be encapsulated.
>
> Could you clarify how egress traffic and ARP/neighbor resolution are expe=
cted to be handled in this way?
> Thanks again, and sorry if I am missing something obvious.
>
> Best regards,
> Yi
>
> On Wed, Jan 7, 2026 at 10:31=E2=80=AFPM Fernando Fernandez Mancera <fmanc=
era@suse.de> wrote:
>>
>> On 12/29/25 2:51 PM, Yi Chen wrote:
>> > Hello Pablo and Fernando,
>> > I have started working on a test script (attached) to exercise this
>> > feature, using a geneve tunnel with an egress hook.
>> > Please let me know if egress is the correct hook to use in this contex=
t.
>> >
>> > However, the behavior is not what I expected: the tunnel template does
>> > not appear to be attached, and even ARP packets are not being
>> > encapsulated.
>> > I would appreciate any guidance on what I might be missing, or
>> > suggestions on how this test could be improved.
>> > Thank you for your time and help.
>> >
>>
>> Hi Yi Chen,
>>
>> As my patch is taking longer than expected because I am polishing all
>> the details related to the tunnel object let me explain it here briefly
>> to unblock you.
>>
>> The tunnel expression/object is used to attach tunnel metadata into a
>> packet so in essence support Lightweight Tunneling (LWT) using Nftables.
>> The LWT support is useful on virtualization environments where the users
>> need to created a lot of tunnels to interconnect containers that are
>> inside different VMs. Instead of creating one interface per container,
>> the idea is that the user can create a single one and then attach the
>> metadata as needed. Imagine the topology described below.
>>
>> +------------------------+                   +------------------------+
>> |--------+          VM A |                   | VM B          +--------|
>> |Box     | +------+ +---+|(192.168.124.49)   +----+ +------+ |Box     |
>> |10.0.0.1|-|vxlan0|-|eth0|-------------------|eth0|-|vxlan0|-|10.0.0.2|
>> |--------+ +------+ +---+|  (192.168.124.134)+----+ +------+ +--------|
>> |                        |                   |                        |
>> |                        |                   |                        |
>> +------------------------+                   +------------------------+
>>
>> We want to reach 10.0.0.2 from 10.0.0.1, the nftables ruleset on VM A
>> will look like this:
>>
>> ```
>> table netdev filter_tunnel {
>>         tunnel vxlan_tmpl {
>>                 id 100
>>                 ip saddr 192.168.124.49
>>                 ip daddr 192.168.124.134
>>                 dport 8472
>>                 ttl 255
>>                 vxlan {
>>                         gbp 100
>>                 }
>>         }
>>
>>         chain redirect_to_tunnel {
>>                 type filter hook ingress device "veth_host" priority fil=
ter; policy
>> accept;
>>                 ip daddr 10.0.0.2 tunnel name "vxlan_tmpl" fwd to "vxlan=
0"
>>         }
>>
>>         chain redirect_from_tunnel {
>>                 type filter hook ingress device "vxlan0" priority filter=
; policy accept;
>>                 ip daddr 10.0.0.1 fwd to "veth_host"
>>         }
>> }
>> ```
>>
>> On VM B the ruleset will be exactly the same but swapping saddr/daddr
>> everywhere, both the external and internal one.
>>
>> The idea behind this feature is to scale up the number of
>> containers/namespaces without creating more VXLAN interfaces. Also, keep
>> on mind that you need to mark the VXLAN as external when creating it, i.=
e
>>
>> ip link add dev vxlan0 type vxlan external
>>
>> After that, you should be able to ping between them:
>>
>> PING 10.0.0.2 (10.0.0.2) 56(84) bytes of data.
>> 64 bytes from 10.0.0.2: icmp_seq=3D1 ttl=3D64 time=3D0.198 ms
>> 64 bytes from 10.0.0.2: icmp_seq=3D2 ttl=3D64 time=3D0.364 ms
>> 64 bytes from 10.0.0.2: icmp_seq=3D3 ttl=3D64 time=3D0.369 ms
>>
>> Please, let me know if something is missing.
>>
>> Thanks,
>> Fernando.
>>
>> >
>> > On Thu, Aug 21, 2025 at 5:18=E2=80=AFPM Fernando Fernandez Mancera
>> > <fmancera@suse.de> wrote:
>> >>
>> >> From: Pablo Neira Ayuso <pablo@netfilter.org>
>> >>
>> >> This patch allows you to attach tunnel metadata through the tunnel
>> >> statement.
>> >>
>> >> The following example shows how to redirect traffic to the erspan0
>> >> tunnel device which will take the tunnel configuration that is
>> >> specified by the ruleset.
>> >>
>> >>       table netdev x {
>> >>              tunnel y {
>> >>                      id 10
>> >>                      ip saddr 192.168.2.10
>> >>                      ip daddr 192.168.2.11
>> >>                      sport 10
>> >>                      dport 20
>> >>                      ttl 10
>> >>                      erspan {
>> >>                              version 1
>> >>                              index 2
>> >>                      }
>> >>              }
>> >>
>> >>              chain x {
>> >>                      type filter hook ingress device veth0 priority 0=
;
>> >>
>> >>                      ip daddr 10.141.10.123 tunnel name y fwd to ersp=
an0
>> >>              }
>> >>       }
>> >>
>> >> This patch also allows to match on tunnel metadata via tunnel express=
ion.
>> >>
>> >> Joint work with Fernando.
>> >>
>> >> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>> >> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
>> >> ---
>> >> v3: rebased
>> >> ---
>> >>   Makefile.am               |  2 +
>> >>   include/expression.h      |  6 +++
>> >>   include/tunnel.h          | 33 ++++++++++++++++
>> >>   src/evaluate.c            |  8 ++++
>> >>   src/expression.c          |  1 +
>> >>   src/netlink_delinearize.c | 17 ++++++++
>> >>   src/netlink_linearize.c   | 14 +++++++
>> >>   src/parser_bison.y        | 33 +++++++++++++---
>> >>   src/scanner.l             |  3 +-
>> >>   src/statement.c           |  1 +
>> >>   src/tunnel.c              | 81 ++++++++++++++++++++++++++++++++++++=
+++
>> >>   11 files changed, 193 insertions(+), 6 deletions(-)
>> >>   create mode 100644 include/tunnel.h
>> >>   create mode 100644 src/tunnel.c
>> >>
>> >> diff --git a/Makefile.am b/Makefile.am
>> >> index 4909abfe..152a80d6 100644
>> >> --- a/Makefile.am
>> >> +++ b/Makefile.am
>> >> @@ -100,6 +100,7 @@ noinst_HEADERS =3D \
>> >>          include/statement.h \
>> >>          include/tcpopt.h \
>> >>          include/trace.h \
>> >> +       include/tunnel.h \
>> >>          include/utils.h \
>> >>          include/xfrm.h \
>> >>          include/xt.h \
>> >> @@ -243,6 +244,7 @@ src_libnftables_la_SOURCES =3D \
>> >>          src/socket.c \
>> >>          src/statement.c \
>> >>          src/tcpopt.c \
>> >> +       src/tunnel.c \
>> >>          src/utils.c \
>> >>          src/xfrm.c \
>> >>          $(NULL)
>> >> diff --git a/include/expression.h b/include/expression.h
>> >> index e483b7e7..7185ee66 100644
>> >> --- a/include/expression.h
>> >> +++ b/include/expression.h
>> >> @@ -77,6 +77,7 @@ enum expr_types {
>> >>          EXPR_NUMGEN,
>> >>          EXPR_HASH,
>> >>          EXPR_RT,
>> >> +       EXPR_TUNNEL,
>> >>          EXPR_FIB,
>> >>          EXPR_XFRM,
>> >>          EXPR_SET_ELEM_CATCHALL,
>> >> @@ -229,6 +230,7 @@ enum expr_flags {
>> >>   #include <hash.h>
>> >>   #include <ct.h>
>> >>   #include <socket.h>
>> >> +#include <tunnel.h>
>> >>   #include <osf.h>
>> >>   #include <xfrm.h>
>> >>
>> >> @@ -368,6 +370,10 @@ struct expr {
>> >>                          enum nft_socket_keys    key;
>> >>                          uint32_t                level;
>> >>                  } socket;
>> >> +               struct {
>> >> +                       /* EXPR_TUNNEL */
>> >> +                       enum nft_tunnel_keys    key;
>> >> +               } tunnel;
>> >>                  struct {
>> >>                          /* EXPR_RT */
>> >>                          enum nft_rt_keys        key;
>> >> diff --git a/include/tunnel.h b/include/tunnel.h
>> >> new file mode 100644
>> >> index 00000000..9e6bd97a
>> >> --- /dev/null
>> >> +++ b/include/tunnel.h
>> >> @@ -0,0 +1,33 @@
>> >> +#ifndef NFTABLES_TUNNEL_H
>> >> +#define NFTABLES_TUNNEL_H
>> >> +
>> >> +/**
>> >> + * struct tunnel_template - template for tunnel expressions
>> >> + *
>> >> + * @token:     parser token for the expression
>> >> + * @dtype:     data type of the expression
>> >> + * @len:       length of the expression
>> >> + * @byteorder: byteorder
>> >> + */
>> >> +struct tunnel_template {
>> >> +       const char              *token;
>> >> +       const struct datatype   *dtype;
>> >> +       enum byteorder          byteorder;
>> >> +       unsigned int            len;
>> >> +};
>> >> +
>> >> +extern const struct tunnel_template tunnel_templates[];
>> >> +
>> >> +#define TUNNEL_TEMPLATE(__token, __dtype, __len, __byteorder) {     =
   \
>> >> +       .token          =3D (__token),                            \
>> >> +       .dtype          =3D (__dtype),                            \
>> >> +       .len            =3D (__len),                              \
>> >> +       .byteorder      =3D (__byteorder),                        \
>> >> +}
>> >> +
>> >> +extern struct expr *tunnel_expr_alloc(const struct location *loc,
>> >> +                                     enum nft_tunnel_keys key);
>> >> +
>> >> +extern const struct expr_ops tunnel_expr_ops;
>> >> +
>> >> +#endif /* NFTABLES_TUNNEL_H */
>> >> diff --git a/src/evaluate.c b/src/evaluate.c
>> >> index da8794dd..6bf14b0c 100644
>> >> --- a/src/evaluate.c
>> >> +++ b/src/evaluate.c
>> >> @@ -1737,6 +1737,7 @@ static int expr_evaluate_concat(struct eval_ctx=
 *ctx, struct expr **expr)
>> >>                  case EXPR_SOCKET:
>> >>                  case EXPR_OSF:
>> >>                  case EXPR_XFRM:
>> >> +               case EXPR_TUNNEL:
>> >>                          break;
>> >>                  case EXPR_RANGE:
>> >>                  case EXPR_PREFIX:
>> >> @@ -3053,6 +3054,11 @@ static int expr_evaluate_osf(struct eval_ctx *=
ctx, struct expr **expr)
>> >>          return expr_evaluate_primary(ctx, expr);
>> >>   }
>> >>
>> >> +static int expr_evaluate_tunnel(struct eval_ctx *ctx, struct expr **=
exprp)
>> >> +{
>> >> +       return expr_evaluate_primary(ctx, exprp);
>> >> +}
>> >> +
>> >>   static int expr_evaluate_variable(struct eval_ctx *ctx, struct expr=
 **exprp)
>> >>   {
>> >>          struct symbol *sym =3D (*exprp)->sym;
>> >> @@ -3170,6 +3176,8 @@ static int expr_evaluate(struct eval_ctx *ctx, =
struct expr **expr)
>> >>                  return expr_evaluate_meta(ctx, expr);
>> >>          case EXPR_SOCKET:
>> >>                  return expr_evaluate_socket(ctx, expr);
>> >> +       case EXPR_TUNNEL:
>> >> +               return expr_evaluate_tunnel(ctx, expr);
>> >>          case EXPR_OSF:
>> >>                  return expr_evaluate_osf(ctx, expr);
>> >>          case EXPR_FIB:
>> >> diff --git a/src/expression.c b/src/expression.c
>> >> index 8cb63979..e3c27a13 100644
>> >> --- a/src/expression.c
>> >> +++ b/src/expression.c
>> >> @@ -1762,6 +1762,7 @@ static const struct expr_ops *__expr_ops_by_typ=
e(enum expr_types etype)
>> >>          case EXPR_NUMGEN: return &numgen_expr_ops;
>> >>          case EXPR_HASH: return &hash_expr_ops;
>> >>          case EXPR_RT: return &rt_expr_ops;
>> >> +       case EXPR_TUNNEL: return &tunnel_expr_ops;
>> >>          case EXPR_FIB: return &fib_expr_ops;
>> >>          case EXPR_XFRM: return &xfrm_expr_ops;
>> >>          case EXPR_SET_ELEM_CATCHALL: return &set_elem_catchall_expr_=
ops;
>> >> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
>> >> index b97962a3..5627826d 100644
>> >> --- a/src/netlink_delinearize.c
>> >> +++ b/src/netlink_delinearize.c
>> >> @@ -940,6 +940,21 @@ static void netlink_parse_osf(struct netlink_par=
se_ctx *ctx,
>> >>          netlink_set_register(ctx, dreg, expr);
>> >>   }
>> >>
>> >> +static void netlink_parse_tunnel(struct netlink_parse_ctx *ctx,
>> >> +                                const struct location *loc,
>> >> +                                const struct nftnl_expr *nle)
>> >> +{
>> >> +       enum nft_registers dreg;
>> >> +       struct expr * expr;
>> >> +       uint32_t key;
>> >> +
>> >> +       key =3D nftnl_expr_get_u32(nle, NFTNL_EXPR_TUNNEL_KEY);
>> >> +       expr =3D tunnel_expr_alloc(loc, key);
>> >> +
>> >> +       dreg =3D netlink_parse_register(nle, NFTNL_EXPR_TUNNEL_DREG);
>> >> +       netlink_set_register(ctx, dreg, expr);
>> >> +}
>> >> +
>> >>   static void netlink_parse_meta_stmt(struct netlink_parse_ctx *ctx,
>> >>                                      const struct location *loc,
>> >>                                      const struct nftnl_expr *nle)
>> >> @@ -1922,6 +1937,7 @@ static const struct expr_handler netlink_parser=
s[] =3D {
>> >>          { .name =3D "exthdr",     .parse =3D netlink_parse_exthdr },
>> >>          { .name =3D "meta",       .parse =3D netlink_parse_meta },
>> >>          { .name =3D "socket",     .parse =3D netlink_parse_socket },
>> >> +       { .name =3D "tunnel",     .parse =3D netlink_parse_tunnel },
>> >>          { .name =3D "osf",        .parse =3D netlink_parse_osf },
>> >>          { .name =3D "rt",         .parse =3D netlink_parse_rt },
>> >>          { .name =3D "ct",         .parse =3D netlink_parse_ct },
>> >> @@ -3023,6 +3039,7 @@ static void expr_postprocess(struct rule_pp_ctx=
 *ctx, struct expr **exprp)
>> >>          case EXPR_NUMGEN:
>> >>          case EXPR_FIB:
>> >>          case EXPR_SOCKET:
>> >> +       case EXPR_TUNNEL:
>> >>          case EXPR_OSF:
>> >>          case EXPR_XFRM:
>> >>                  break;
>> >> diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
>> >> index 8ac33d34..d01cadf8 100644
>> >> --- a/src/netlink_linearize.c
>> >> +++ b/src/netlink_linearize.c
>> >> @@ -334,6 +334,18 @@ static void netlink_gen_osf(struct netlink_linea=
rize_ctx *ctx,
>> >>          nft_rule_add_expr(ctx, nle, &expr->location);
>> >>   }
>> >>
>> >> +static void netlink_gen_tunnel(struct netlink_linearize_ctx *ctx,
>> >> +                              const struct expr *expr,
>> >> +                              enum nft_registers dreg)
>> >> +{
>> >> +       struct nftnl_expr *nle;
>> >> +
>> >> +       nle =3D alloc_nft_expr("tunnel");
>> >> +       netlink_put_register(nle, NFTNL_EXPR_TUNNEL_DREG, dreg);
>> >> +       nftnl_expr_set_u32(nle, NFTNL_EXPR_TUNNEL_KEY, expr->tunnel.k=
ey);
>> >> +       nftnl_rule_add_expr(ctx->nlr, nle);
>> >> +}
>> >> +
>> >>   static void netlink_gen_numgen(struct netlink_linearize_ctx *ctx,
>> >>                              const struct expr *expr,
>> >>                              enum nft_registers dreg)
>> >> @@ -932,6 +944,8 @@ static void netlink_gen_expr(struct netlink_linea=
rize_ctx *ctx,
>> >>                  return netlink_gen_fib(ctx, expr, dreg);
>> >>          case EXPR_SOCKET:
>> >>                  return netlink_gen_socket(ctx, expr, dreg);
>> >> +       case EXPR_TUNNEL:
>> >> +               return netlink_gen_tunnel(ctx, expr, dreg);
>> >>          case EXPR_OSF:
>> >>                  return netlink_gen_osf(ctx, expr, dreg);
>> >>          case EXPR_XFRM:
>> >> diff --git a/src/parser_bison.y b/src/parser_bison.y
>> >> index 557977e2..08d75dbb 100644
>> >> --- a/src/parser_bison.y
>> >> +++ b/src/parser_bison.y
>> >> @@ -321,6 +321,8 @@ int nft_lex(void *, void *, void *);
>> >>   %token RULESET                 "ruleset"
>> >>   %token TRACE                   "trace"
>> >>
>> >> +%token PATH                    "path"
>> >> +
>> >>   %token INET                    "inet"
>> >>   %token NETDEV                  "netdev"
>> >>
>> >> @@ -779,8 +781,8 @@ int nft_lex(void *, void *, void *);
>> >>   %destructor { stmt_free($$); } counter_stmt counter_stmt_alloc stat=
eful_stmt last_stmt
>> >>   %type <stmt>                   limit_stmt_alloc quota_stmt_alloc la=
st_stmt_alloc ct_limit_stmt_alloc
>> >>   %destructor { stmt_free($$); } limit_stmt_alloc quota_stmt_alloc la=
st_stmt_alloc ct_limit_stmt_alloc
>> >> -%type <stmt>                   objref_stmt objref_stmt_counter objre=
f_stmt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy
>> >> -%destructor { stmt_free($$); } objref_stmt objref_stmt_counter objre=
f_stmt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy
>> >> +%type <stmt>                   objref_stmt objref_stmt_counter objre=
f_stmt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy objref_s=
tmt_tunnel
>> >> +%destructor { stmt_free($$); } objref_stmt objref_stmt_counter objre=
f_stmt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy objref_s=
tmt_tunnel
>> >>
>> >>   %type <stmt>                   payload_stmt
>> >>   %destructor { stmt_free($$); } payload_stmt
>> >> @@ -940,9 +942,9 @@ int nft_lex(void *, void *, void *);
>> >>   %destructor { expr_free($$); } mh_hdr_expr
>> >>   %type <val>                    mh_hdr_field
>> >>
>> >> -%type <expr>                   meta_expr
>> >> -%destructor { expr_free($$); } meta_expr
>> >> -%type <val>                    meta_key        meta_key_qualified   =
   meta_key_unqualified    numgen_type
>> >> +%type <expr>                   meta_expr       tunnel_expr
>> >> +%destructor { expr_free($$); } meta_expr       tunnel_expr
>> >> +%type <val>                    meta_key        meta_key_qualified   =
   meta_key_unqualified    numgen_type     tunnel_key
>> >>
>> >>   %type <expr>                   socket_expr
>> >>   %destructor { expr_free($$); } socket_expr
>> >> @@ -3206,6 +3208,14 @@ objref_stmt_synproxy     :       SYNPROXY     =
   NAME    stmt_expr close_scope_synproxy
>> >>                          }
>> >>                          ;
>> >>
>> >> +objref_stmt_tunnel     :       TUNNEL  NAME    stmt_expr       close=
_scope_tunnel
>> >> +                       {
>> >> +                               $$ =3D objref_stmt_alloc(&@$);
>> >> +                               $$->objref.type =3D NFT_OBJECT_TUNNEL=
;
>> >> +                               $$->objref.expr =3D $3;
>> >> +                       }
>> >> +                       ;
>> >> +
>> >>   objref_stmt_ct         :       CT      TIMEOUT         SET     stmt=
_expr       close_scope_ct
>> >>                          {
>> >>                                  $$ =3D objref_stmt_alloc(&@$);
>> >> @@ -3226,6 +3236,7 @@ objref_stmt               :       objref_stmt_c=
ounter
>> >>                          |       objref_stmt_quota
>> >>                          |       objref_stmt_synproxy
>> >>                          |       objref_stmt_ct
>> >> +                       |       objref_stmt_tunnel
>> >>                          ;
>> >>
>> >>   stateful_stmt          :       counter_stmt    close_scope_counter
>> >> @@ -3904,6 +3915,7 @@ primary_stmt_expr :       symbol_expr          =
           { $$ =3D $1; }
>> >>                          |       boolean_expr                    { $$=
 =3D $1; }
>> >>                          |       meta_expr                       { $$=
 =3D $1; }
>> >>                          |       rt_expr                         { $$=
 =3D $1; }
>> >> +                       |       tunnel_expr                     { $$ =
=3D $1; }
>> >>                          |       ct_expr                         { $$=
 =3D $1; }
>> >>                          |       numgen_expr                     { $$=
 =3D $1; }
>> >>                          |       hash_expr                       { $$=
 =3D $1; }
>> >> @@ -4381,6 +4393,7 @@ selector_expr             :       payload_expr =
                   { $$ =3D $1; }
>> >>                          |       exthdr_expr                     { $$=
 =3D $1; }
>> >>                          |       exthdr_exists_expr              { $$=
 =3D $1; }
>> >>                          |       meta_expr                       { $$=
 =3D $1; }
>> >> +                       |       tunnel_expr                     { $$ =
=3D $1; }
>> >>                          |       socket_expr                     { $$=
 =3D $1; }
>> >>                          |       rt_expr                         { $$=
 =3D $1; }
>> >>                          |       ct_expr                         { $$=
 =3D $1; }
>> >> @@ -5493,6 +5506,16 @@ socket_key               :       TRANSPARENT  =
   { $$ =3D NFT_SOCKET_TRANSPARENT; }
>> >>                          |       WILDCARD        { $$ =3D NFT_SOCKET_=
WILDCARD; }
>> >>                          ;
>> >>
>> >> +tunnel_key             :       PATH            { $$ =3D NFT_TUNNEL_P=
ATH; }
>> >> +                       |       ID              { $$ =3D NFT_TUNNEL_I=
D; }
>> >> +                       ;
>> >> +
>> >> +tunnel_expr            :       TUNNEL  tunnel_key
>> >> +                       {
>> >> +                               $$ =3D tunnel_expr_alloc(&@$, $2);
>> >> +                       }
>> >> +                       ;
>> >> +
>> >>   offset_opt             :       /* empty */     { $$ =3D 0; }
>> >>                          |       OFFSET  NUM     { $$ =3D $2; }
>> >>                          ;
>> >> diff --git a/src/scanner.l b/src/scanner.l
>> >> index def0ac0e..9695d710 100644
>> >> --- a/src/scanner.l
>> >> +++ b/src/scanner.l
>> >> @@ -410,7 +410,7 @@ addrstring  ({macaddr}|{ip4addr}|{ip6addr})
>> >>   }
>> >>
>> >>   "counter"              { scanner_push_start_cond(yyscanner, SCANSTA=
TE_COUNTER); return COUNTER; }
>> >> -<SCANSTATE_COUNTER,SCANSTATE_LIMIT,SCANSTATE_QUOTA,SCANSTATE_STMT_SY=
NPROXY,SCANSTATE_EXPR_OSF>"name"                   { return NAME; }
>> >> +<SCANSTATE_COUNTER,SCANSTATE_LIMIT,SCANSTATE_QUOTA,SCANSTATE_STMT_SY=
NPROXY,SCANSTATE_EXPR_OSF,SCANSTATE_TUNNEL>"name"                  { return=
 NAME; }
>> >>   <SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT>"packets"          =
    { return PACKETS; }
>> >>   <SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT,SCANSTATE_QUOTA>"by=
tes"        { return BYTES; }
>> >>
>> >> @@ -826,6 +826,7 @@ addrstring  ({macaddr}|{ip4addr}|{ip6addr})
>> >>          "erspan"                { return ERSPAN; }
>> >>          "egress"                { return EGRESS; }
>> >>          "ingress"               { return INGRESS; }
>> >> +       "path"                  { return PATH; }
>> >>   }
>> >>
>> >>   "notrack"              { return NOTRACK; }
>> >> diff --git a/src/statement.c b/src/statement.c
>> >> index 2bfed4ac..20241f68 100644
>> >> --- a/src/statement.c
>> >> +++ b/src/statement.c
>> >> @@ -290,6 +290,7 @@ static const char *objref_type[NFT_OBJECT_MAX + 1=
] =3D {
>> >>          [NFT_OBJECT_QUOTA]      =3D "quota",
>> >>          [NFT_OBJECT_CT_HELPER]  =3D "ct helper",
>> >>          [NFT_OBJECT_LIMIT]      =3D "limit",
>> >> +       [NFT_OBJECT_TUNNEL]     =3D "tunnel",
>> >>          [NFT_OBJECT_CT_TIMEOUT] =3D "ct timeout",
>> >>          [NFT_OBJECT_SECMARK]    =3D "secmark",
>> >>          [NFT_OBJECT_SYNPROXY]   =3D "synproxy",
>> >> diff --git a/src/tunnel.c b/src/tunnel.c
>> >> new file mode 100644
>> >> index 00000000..cd92d039
>> >> --- /dev/null
>> >> +++ b/src/tunnel.c
>> >> @@ -0,0 +1,81 @@
>> >> +/*
>> >> + * Copyright (c) 2018 Pablo Neira Ayuso <pablo@netfilter.org>
>> >> + *
>> >> + * This program is free software; you can redistribute it and/or mod=
ify
>> >> + * it under the terms of the GNU General Public License version 2 as
>> >> + * published by the Free Software Foundation.
>> >> + */
>> >> +
>> >> +#include <errno.h>
>> >> +#include <limits.h>
>> >> +#include <stddef.h>
>> >> +#include <stdlib.h>
>> >> +#include <stdio.h>
>> >> +#include <stdbool.h>
>> >> +#include <stdint.h>
>> >> +#include <string.h>
>> >> +#include <net/if.h>
>> >> +#include <net/if_arp.h>
>> >> +#include <pwd.h>
>> >> +#include <grp.h>
>> >> +#include <arpa/inet.h>
>> >> +#include <linux/netfilter.h>
>> >> +#include <linux/pkt_sched.h>
>> >> +#include <linux/if_packet.h>
>> >> +
>> >> +#include <nftables.h>
>> >> +#include <expression.h>
>> >> +#include <datatype.h>
>> >> +#include <tunnel.h>
>> >> +#include <gmputil.h>
>> >> +#include <utils.h>
>> >> +#include <erec.h>
>> >> +
>> >> +const struct tunnel_template tunnel_templates[] =3D {
>> >> +       [NFT_TUNNEL_PATH]       =3D META_TEMPLATE("path", &boolean_ty=
pe,
>> >> +                                               BITS_PER_BYTE, BYTEOR=
DER_HOST_ENDIAN),
>> >> +       [NFT_TUNNEL_ID]         =3D META_TEMPLATE("id",  &integer_typ=
e,
>> >> +                                               4 * 8, BYTEORDER_HOST=
_ENDIAN),
>> >> +};
>> >> +
>> >> +static void tunnel_expr_print(const struct expr *expr, struct output=
_ctx *octx)
>> >> +{
>> >> +       uint32_t key =3D expr->tunnel.key;
>> >> +       const char *token =3D "unknown";
>> >> +
>> >> +       if (key < array_size(tunnel_templates))
>> >> +               token =3D tunnel_templates[key].token;
>> >> +
>> >> +       nft_print(octx, "tunnel %s", token);
>> >> +}
>> >> +
>> >> +static bool tunnel_expr_cmp(const struct expr *e1, const struct expr=
 *e2)
>> >> +{
>> >> +       return e1->tunnel.key =3D=3D e2->tunnel.key;
>> >> +}
>> >> +
>> >> +static void tunnel_expr_clone(struct expr *new, const struct expr *e=
xpr)
>> >> +{
>> >> +       new->tunnel.key =3D expr->tunnel.key;
>> >> +}
>> >> +
>> >> +const struct expr_ops tunnel_expr_ops =3D {
>> >> +       .type           =3D EXPR_TUNNEL,
>> >> +       .name           =3D "tunnel",
>> >> +       .print          =3D tunnel_expr_print,
>> >> +       .cmp            =3D tunnel_expr_cmp,
>> >> +       .clone          =3D tunnel_expr_clone,
>> >> +};
>> >> +
>> >> +struct expr *tunnel_expr_alloc(const struct location *loc,
>> >> +                              enum nft_tunnel_keys key)
>> >> +{
>> >> +       const struct tunnel_template *tmpl =3D &tunnel_templates[key]=
;
>> >> +       struct expr *expr;
>> >> +
>> >> +       expr =3D expr_alloc(loc, EXPR_TUNNEL, tmpl->dtype, tmpl->byte=
order,
>> >> +                         tmpl->len);
>> >> +       expr->tunnel.key =3D key;
>> >> +
>> >> +       return expr;
>> >> +}
>> >> --
>> >> 2.50.1
>> >>
>> >>
>>

