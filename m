From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: Re: [PATCH v2] nftables: Add support for reserved header and addrs
 for routing header type 0
Date: Wed, 11 Oct 2017 22:20:42 +0530
Message-ID: <CANMOCy1XzJsgYxYyE-RyOEQ8HGmh5F+PW2=FLeauzdgZd+Kb_g@mail.gmail.com>
References: <20171006073659.10302-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org,
        outreachy-kernel <outreachy-kernel@googlegroups.com>,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:34931 "EHLO
        mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752221AbdJKQuo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2017 12:50:44 -0400
Received: by mail-vk0-f68.google.com with SMTP id h191so680036vke.2
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Oct 2017 09:50:43 -0700 (PDT)
In-Reply-To: <20171006073659.10302-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 6, 2017 at 1:06 PM, Harsha Sharma
<harshasharmaiitr@gmail.com> wrote:
> Add support for IPV6 routing header type 0 reserved field and addresses
> with corresponding tests
>
> Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
> ---
> For struct exthdr_rt0, I have specified type to be IPPROTO_ROUTING
> due to which when exthdr_init_raw is called in exthdr_find_template
> which initialises expr->exthdr.desc to exthdr_protocols[type] and
> that will be $exthdr_rt and not &exthdr_rt0, when testing the
> testcases this warning comes 'rt0 rserved 2' mismatches 'rt unknown
> 0x2' and same for the addrs. Fot this one possible way is to define
> IPPROTO_ROUTING0 in header file in /usr/include/. Can anyone please
> suggest what will be the best way to fix these warnings ?
> I'll add more testcases once these warnings are fixed.
> Thanks.
>
> Changes in v2:
>  -Changed log message
>  -Added tests and removed errors but warning is still there
>
>  include/exthdr.h           |  2 ++
>  src/exthdr.c               |  4 ++--
>  src/parser_bison.y         |  6 ++----
>  tests/py/ip6/rt0.t         |  4 ++++
>  tests/py/ip6/rt0.t.payload | 14 ++++++++++++++
>  5 files changed, 24 insertions(+), 6 deletions(-)
>
> diff --git a/include/exthdr.h b/include/exthdr.h
> index 97ccc38..3930108 100644
> --- a/include/exthdr.h
> +++ b/include/exthdr.h
> @@ -14,6 +14,8 @@
>  struct exthdr_desc {
>         const char                      *name;
>         uint8_t                         type;
> +       unsigned int                    protocol_key;
> +       const struct exthdr_desc        *protocols[3];
>         struct proto_hdr_template       templates[10];
>  };
>
> diff --git a/src/exthdr.c b/src/exthdr.c
> index ac3e163..ddd0018 100644
> --- a/src/exthdr.c
> +++ b/src/exthdr.c
> @@ -246,6 +246,8 @@ const struct exthdr_desc exthdr_rt2 = {
>         HDR_TEMPLATE(__name, __dtype, struct ip6_rthdr0, __member)
>
>  const struct exthdr_desc exthdr_rt0 = {
> +       .name           = "rt0",
> +       .type           = IPPROTO_ROUTING,
>         .templates      = {
>                 [RT0HDR_RESERVED]       = RT0_FIELD("reserved", ip6r0_reserved, &integer_type),
>                 [RT0HDR_ADDR_1]         = RT0_FIELD("addr[1]", ip6r0_addr[0], &ip6addr_type),
> @@ -260,13 +262,11 @@ const struct exthdr_desc exthdr_rt0 = {
>  const struct exthdr_desc exthdr_rt = {
>         .name           = "rt",
>         .type           = IPPROTO_ROUTING,
> -#if 0
>         .protocol_key   = RTHDR_TYPE,
>         .protocols      = {
>                 [0]     = &exthdr_rt0,
>                 [2]     = &exthdr_rt2,
>         },
> -#endif
>         .templates      = {
>                 [RTHDR_NEXTHDR]         = RT_FIELD("nexthdr", ip6r_nxt, &inet_protocol_type),
>                 [RTHDR_HDRLENGTH]       = RT_FIELD("hdrlength", ip6r_len, &integer_type),
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index 7016f5b..7c4e775 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -3697,10 +3697,8 @@ rt0_hdr_expr             :       RT0     rt0_hdr_field
>                         }
>                         ;
>
> -rt0_hdr_field          :       ADDR    '['     NUM     ']'
> -                       {
> -                               $$ = RT0HDR_ADDR_1 + $3 - 1;
> -                       }
> +rt0_hdr_field          :       ADDR'['NUM']'   { $$ = RT0HDR_ADDR_1 + $3 - 1;}
> +                       |       RESERVED        { $$ = RT0HDR_RESERVED; }
>                         ;
>
>  rt2_hdr_expr           :       RT2     rt2_hdr_field
> diff --git a/tests/py/ip6/rt0.t b/tests/py/ip6/rt0.t
> index 1d50a89..ebbae75 100644
> --- a/tests/py/ip6/rt0.t
> +++ b/tests/py/ip6/rt0.t
> @@ -4,3 +4,7 @@
>
>  rt nexthop 192.168.0.1;fail
>  rt nexthop fd00::1;ok;rt ip6 nexthop fd00::1
> +
> +rt0 reserved 2;ok
> +rt0 addr [1] 2001:db8:0:1:1:1:1:1;ok
> +rt0 addr [2] 2001:db8:0:0:0:0:1:1;ok
> diff --git a/tests/py/ip6/rt0.t.payload b/tests/py/ip6/rt0.t.payload
> index 464b7f2..69577e7 100644
> --- a/tests/py/ip6/rt0.t.payload
> +++ b/tests/py/ip6/rt0.t.payload
> @@ -3,3 +3,17 @@ ip6 test-ip6 output
>    [ rt load nexthop6 => reg 1 ]
>    [ cmp eq reg 1 0x000000fd 0x00000000 0x00000000 0x01000000 ]
>
> +# rt0 reserved 2
> +ip6 test-ip6 output
> +  [ exthdr load 1b @ 43 + 4 => reg 1 ]
> +  [ cmp eq reg 1 0x00000002 ]
> +
> +# rt0 addr [1] 2001:db8:0:1:1:1:1:1
> +ip6 test-ip6 output
> +  [ exthdr load 16b @ 43 + 8 => reg 1 ]
> +  [ cmp eq reg 1 0xb80d0120 0x01000000 0x01000100 0x01000100 ]
> +
> +# rt0 addr [2] 2001:db8:0:0:0:0:1:1
> +ip6 test-ip6 output
> +  [ exthdr load 16b @ 43 + 8 => reg 1 ]
> +  [ cmp eq reg 1 0xb80d0120 0x00000000 0x00000000 0x01000100 ]

Hi,
Any updates on this ?
Thanks for your time.

Regards,
Harsha Sharma

> --
> 2.11.0
>
