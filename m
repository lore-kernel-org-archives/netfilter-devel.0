Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA0F5C61DB3
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Jan 2023 19:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235738AbjAFTfQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Jan 2023 14:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235692AbjAFTer (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Jan 2023 14:34:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35EEFF9
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Jan 2023 11:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673033642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oqSrHBgVGdQs7igadXzC/agHVmYl7v7f2ShZi6uH4ig=;
        b=Q99bintcwvnEylvJZ505r1lGhgO5uxsK//u7cUoEfODNN0pNS/iA1xgALsZgPTgOIXXzB4
        iDhUHU73cAMhQHzL47x6ITECIZTD6ahK8byrzAUG41UvW4R6kGj8vkQskNAw1o92ciNgDX
        Vj7KHdKHGY3k2FcfJum0WcKkFzJWJ4k=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-463-dFHno8I4NYa6wjGdNWAgBw-1; Fri, 06 Jan 2023 14:30:24 -0500
X-MC-Unique: dFHno8I4NYa6wjGdNWAgBw-1
Received: by mail-lj1-f200.google.com with SMTP id bn17-20020a05651c179100b0027905fa8e48so702988ljb.15
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Jan 2023 11:30:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oqSrHBgVGdQs7igadXzC/agHVmYl7v7f2ShZi6uH4ig=;
        b=pyluMwsR4Gm+p2/nBZ8dv3sgi4pBR2G6Fa8rFfEPmHuUvgCzE2J+K7H9WwB4YUFStk
         0N2AYBYy0UMgGyhatd/fK12K9PAmK56rvyhsnC8b1YZxb+4zV6aeEwvAxULgwrb1lAg7
         F/OsOQiIFd97QfBuPt4a9ONJxKA5dHlVNCU7OLe2xhMOdOOuv/7qOJZyWRwUxd7uVYsJ
         q9lagucFyqCYQsNLXGkZL/S7Yxfv8NF3klkvajq9q75WcH0JN3uc6tMxMUGNOKm+H2S1
         hWEGXizb9JCSFQPnnt+4nTrKzoFucKg5b5R9y93m4iuXxsEpdKtHoxeMnSzX5AGL9tYF
         1Unw==
X-Gm-Message-State: AFqh2korP0HCRgiXFBYGHl1lQbsM+/wSeW3uTZoW+0H7FRA8IVPVde9D
        4tvMRJBRg6l2edh0tcgtIZMKWkKZ8+BvUWXZ40C1rUEO6a/wsX9/DX+1vWt1ukO3LZ8DztgWNva
        PBaufH5tQ4UZ6oj3uQS8gRvHtm+ekDUX3i6NMNkY0WBq2
X-Received: by 2002:a2e:b521:0:b0:281:5fe:f4aa with SMTP id z1-20020a2eb521000000b0028105fef4aamr907547ljm.232.1673033422518;
        Fri, 06 Jan 2023 11:30:22 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtsLZLZP4Ox4Jmjg9gjYB1UZdSvixnB+rbPwibC/1dTW2kTB25ZA9OU0fnT+BZVMB854xQFAnvX0sj/7+R/nhM=
X-Received: by 2002:a2e:b521:0:b0:281:5fe:f4aa with SMTP id
 z1-20020a2eb521000000b0028105fef4aamr907540ljm.232.1673033422119; Fri, 06 Jan
 2023 11:30:22 -0800 (PST)
MIME-Version: 1.0
References: <20230105114740.27882-1-sriram.yagnaraman@est.tech>
In-Reply-To: <20230105114740.27882-1-sriram.yagnaraman@est.tech>
From:   Long Xin <lxin@redhat.com>
Date:   Fri, 6 Jan 2023 14:28:44 -0500
Message-ID: <CAMApiK_rTJi7w+pyOQwC43rFnuusMRVXZM6GhSSi8H9StfoxnA@mail.gmail.com>
Subject: Re: [RFC PATCH v2] netfilter: conntrack: simplify sctp state machine
To:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>
Content-Type: multipart/mixed; boundary="000000000000d2cb3005f19d720a"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--000000000000d2cb3005f19d720a
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 5, 2023 at 6:47 AM Sriram Yagnaraman
<sriram.yagnaraman@est.tech> wrote:
>
> All the paths in an SCTP connection are kept alive either by actual
> DATA/SACK running through the connection or by HEARTBEAT. This patch
> proposes a simple state machine with only two states OPEN_WAIT and
> ESTABLISHED (similar to UDP). The reason for this change is a full
> stateful approach to SCTP is difficult when the association is
> multihomed since the endpoints could use different paths in the network
> during the lifetime of an association.
>
> Default timeouts are:
> OPEN_WAIT:   3 seconds   (rto_initial)
> ESTABLISHED: 210 seconds (rto_max + hb_interval * path_max_retrans)
>
> Important changes/notes
> - Timeout is used to clean up conntrack entries
> - VTAG checks are kept as is (can be moved to a conntrack extension if
>   desired)
> - SCTP chunks are parsed only once, and a map is populated with the
>   information on the chunks present in the packet
> - ASSURED bit is NOT set in this version of the patch, need help
>   understanding when to set it
I can still see a regression from the change:

After the 1st connection shutdown successfully, the 2nd connection
with the same 4-tuple will fail as the old conntrack entry stays in
ESTABLISHED and waits to time out.

This is actually acting differently from TCP and UDP NAT.
Attached is a script to help reproduce it.

Thanks.

>
>
> Changes since v1:
> - sctp_new() brought back for unconfirmed CT entries
> - sctp_vtag_check() does all vtag related check, except for
>   HEARTBEAT/HEARTBEACK_ACK chunks
> - Style check fixes
> - Revert all UAPI changes
>
> Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
> ---
>  .../uapi/linux/netfilter/nf_conntrack_sctp.h  |   1 +
>  .../linux/netfilter/nfnetlink_cttimeout.h     |   1 +
>  net/netfilter/nf_conntrack_proto_sctp.c       | 624 +++++-------------
>  net/netfilter/nf_conntrack_standalone.c       |  72 +-
>  4 files changed, 179 insertions(+), 519 deletions(-)
>
> diff --git a/include/uapi/linux/netfilter/nf_conntrack_sctp.h b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
> index c742469afe21..703c2ae5adf4 100644
> --- a/include/uapi/linux/netfilter/nf_conntrack_sctp.h
> +++ b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
> @@ -9,6 +9,7 @@ enum sctp_conntrack {
>         SCTP_CONNTRACK_NONE,
>         SCTP_CONNTRACK_CLOSED,
>         SCTP_CONNTRACK_COOKIE_WAIT,
> +       SCTP_CONNTRACK_OPEN_WAIT = SCTP_CONNTRACK_COOKIE_WAIT,
>         SCTP_CONNTRACK_COOKIE_ECHOED,
>         SCTP_CONNTRACK_ESTABLISHED,
>         SCTP_CONNTRACK_SHUTDOWN_SENT,
> diff --git a/include/uapi/linux/netfilter/nfnetlink_cttimeout.h b/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
> index 94e74034706d..a76ea744d3e3 100644
> --- a/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
> +++ b/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
> @@ -88,6 +88,7 @@ enum ctattr_timeout_sctp {
>         CTA_TIMEOUT_SCTP_UNSPEC,
>         CTA_TIMEOUT_SCTP_CLOSED,
>         CTA_TIMEOUT_SCTP_COOKIE_WAIT,
> +       CTA_TIMEOUT_SCTP_OPEN_WAIT = CTA_TIMEOUT_SCTP_COOKIE_WAIT,
>         CTA_TIMEOUT_SCTP_COOKIE_ECHOED,
>         CTA_TIMEOUT_SCTP_ESTABLISHED,
>         CTA_TIMEOUT_SCTP_SHUTDOWN_SENT,
> diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
> index d88b92a8ffca..8c18528972b7 100644
> --- a/net/netfilter/nf_conntrack_proto_sctp.c
> +++ b/net/netfilter/nf_conntrack_proto_sctp.c
> @@ -5,12 +5,13 @@
>   * Copyright (c) 2004 Kiran Kumar Immidi <immidi_kiran@yahoo.com>
>   * Copyright (c) 2004-2012 Patrick McHardy <kaber@trash.net>
>   *
> - * SCTP is defined in RFC 2960. References to various sections in this code
> + * SCTP is defined in RFC 4960. References to various sections in this code
>   * are to this RFC.
>   */
>
>  #include <linux/types.h>
>  #include <linux/timer.h>
> +#include <linux/jiffies.h>
>  #include <linux/netfilter.h>
>  #include <linux/in.h>
>  #include <linux/ip.h>
> @@ -27,127 +28,19 @@
>  #include <net/netfilter/nf_conntrack_ecache.h>
>  #include <net/netfilter/nf_conntrack_timeout.h>
>
> -/* FIXME: Examine ipfilter's timeouts and conntrack transitions more
> -   closely.  They're more complex. --RR
> -
> -   And so for me for SCTP :D -Kiran */
> +#define        SCTP_FLAG_HEARTBEAT_VTAG_FAILED 1
>
>  static const char *const sctp_conntrack_names[] = {
>         "NONE",
> -       "CLOSED",
> -       "COOKIE_WAIT",
> -       "COOKIE_ECHOED",
> +       "OPEN_WAIT",
>         "ESTABLISHED",
> -       "SHUTDOWN_SENT",
> -       "SHUTDOWN_RECD",
> -       "SHUTDOWN_ACK_SENT",
> -       "HEARTBEAT_SENT",
> -       "HEARTBEAT_ACKED",
>  };
>
>  #define SECS  * HZ
> -#define MINS  * 60 SECS
> -#define HOURS * 60 MINS
> -#define DAYS  * 24 HOURS
>
>  static const unsigned int sctp_timeouts[SCTP_CONNTRACK_MAX] = {
> -       [SCTP_CONNTRACK_CLOSED]                 = 10 SECS,
> -       [SCTP_CONNTRACK_COOKIE_WAIT]            = 3 SECS,
> -       [SCTP_CONNTRACK_COOKIE_ECHOED]          = 3 SECS,
> -       [SCTP_CONNTRACK_ESTABLISHED]            = 5 DAYS,
> -       [SCTP_CONNTRACK_SHUTDOWN_SENT]          = 300 SECS / 1000,
> -       [SCTP_CONNTRACK_SHUTDOWN_RECD]          = 300 SECS / 1000,
> -       [SCTP_CONNTRACK_SHUTDOWN_ACK_SENT]      = 3 SECS,
> -       [SCTP_CONNTRACK_HEARTBEAT_SENT]         = 30 SECS,
> -       [SCTP_CONNTRACK_HEARTBEAT_ACKED]        = 210 SECS,
> -       [SCTP_CONNTRACK_DATA_SENT]              = 30 SECS,
> -};
> -
> -#define        SCTP_FLAG_HEARTBEAT_VTAG_FAILED 1
> -
> -#define sNO SCTP_CONNTRACK_NONE
> -#define        sCL SCTP_CONNTRACK_CLOSED
> -#define        sCW SCTP_CONNTRACK_COOKIE_WAIT
> -#define        sCE SCTP_CONNTRACK_COOKIE_ECHOED
> -#define        sES SCTP_CONNTRACK_ESTABLISHED
> -#define        sSS SCTP_CONNTRACK_SHUTDOWN_SENT
> -#define        sSR SCTP_CONNTRACK_SHUTDOWN_RECD
> -#define        sSA SCTP_CONNTRACK_SHUTDOWN_ACK_SENT
> -#define        sHS SCTP_CONNTRACK_HEARTBEAT_SENT
> -#define        sHA SCTP_CONNTRACK_HEARTBEAT_ACKED
> -#define        sDS SCTP_CONNTRACK_DATA_SENT
> -#define        sIV SCTP_CONNTRACK_MAX
> -
> -/*
> -       These are the descriptions of the states:
> -
> -NOTE: These state names are tantalizingly similar to the states of an
> -SCTP endpoint. But the interpretation of the states is a little different,
> -considering that these are the states of the connection and not of an end
> -point. Please note the subtleties. -Kiran
> -
> -NONE              - Nothing so far.
> -COOKIE WAIT       - We have seen an INIT chunk in the original direction, or also
> -                   an INIT_ACK chunk in the reply direction.
> -COOKIE ECHOED     - We have seen a COOKIE_ECHO chunk in the original direction.
> -ESTABLISHED       - We have seen a COOKIE_ACK in the reply direction.
> -SHUTDOWN_SENT     - We have seen a SHUTDOWN chunk in the original direction.
> -SHUTDOWN_RECD     - We have seen a SHUTDOWN chunk in the reply direction.
> -SHUTDOWN_ACK_SENT - We have seen a SHUTDOWN_ACK chunk in the direction opposite
> -                   to that of the SHUTDOWN chunk.
> -CLOSED            - We have seen a SHUTDOWN_COMPLETE chunk in the direction of
> -                   the SHUTDOWN chunk. Connection is closed.
> -HEARTBEAT_SENT    - We have seen a HEARTBEAT in a new flow.
> -HEARTBEAT_ACKED   - We have seen a HEARTBEAT-ACK/DATA/SACK in the direction
> -                   opposite to that of the HEARTBEAT/DATA chunk. Secondary connection
> -                   is established.
> -DATA_SENT         - We have seen a DATA/SACK in a new flow.
> -*/
> -
> -/* TODO
> - - I have assumed that the first INIT is in the original direction.
> - This messes things when an INIT comes in the reply direction in CLOSED
> - state.
> - - Check the error type in the reply dir before transitioning from
> -cookie echoed to closed.
> - - Sec 5.2.4 of RFC 2960
> - - Full Multi Homing support.
> -*/
> -
> -/* SCTP conntrack state transitions */
> -static const u8 sctp_conntracks[2][12][SCTP_CONNTRACK_MAX] = {
> -       {
> -/*     ORIGINAL        */
> -/*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA, sDS */
> -/* init         */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCW, sHA, sCW},
> -/* init_ack     */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL, sHA, sCL},
> -/* abort        */ {sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL},
> -/* shutdown     */ {sCL, sCL, sCW, sCE, sSS, sSS, sSR, sSA, sCL, sSS, sCL},
> -/* shutdown_ack */ {sSA, sCL, sCW, sCE, sES, sSA, sSA, sSA, sSA, sHA, sSA},
> -/* error        */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL, sHA, sCL},/* Can't have Stale cookie*/
> -/* cookie_echo  */ {sCL, sCL, sCE, sCE, sES, sSS, sSR, sSA, sCL, sHA, sCL},/* 5.2.4 - Big TODO */
> -/* cookie_ack   */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL, sHA, sCL},/* Can't come in orig dir */
> -/* shutdown_comp*/ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sCL, sCL, sHA, sCL},
> -/* heartbeat    */ {sHS, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA, sDS},
> -/* heartbeat_ack*/ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA, sDS},
> -/* data/sack    */ {sDS, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA, sDS}
> -       },
> -       {
> -/*     REPLY   */
> -/*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA, sDS */
> -/* init         */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA, sIV},/* INIT in sCL Big TODO */
> -/* init_ack     */ {sIV, sCW, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA, sIV},
> -/* abort        */ {sIV, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sIV, sCL, sIV},
> -/* shutdown     */ {sIV, sCL, sCW, sCE, sSR, sSS, sSR, sSA, sIV, sSR, sIV},
> -/* shutdown_ack */ {sIV, sCL, sCW, sCE, sES, sSA, sSA, sSA, sIV, sHA, sIV},
> -/* error        */ {sIV, sCL, sCW, sCL, sES, sSS, sSR, sSA, sIV, sHA, sIV},
> -/* cookie_echo  */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA, sIV},/* Can't come in reply dir */
> -/* cookie_ack   */ {sIV, sCL, sCW, sES, sES, sSS, sSR, sSA, sIV, sHA, sIV},
> -/* shutdown_comp*/ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sCL, sIV, sHA, sIV},
> -/* heartbeat    */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA, sHA},
> -/* heartbeat_ack*/ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHA, sHA, sHA},
> -/* data/sack    */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHA, sHA, sHA},
> -       }
> +       [SCTP_CONNTRACK_OPEN_WAIT]                      = 3 SECS,
> +       [SCTP_CONNTRACK_ESTABLISHED]            = 210 SECS,
>  };
>
>  #ifdef CONFIG_NF_CONNTRACK_PROCFS
> @@ -158,184 +51,6 @@ static void sctp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
>  }
>  #endif
>
> -#define for_each_sctp_chunk(skb, sch, _sch, offset, dataoff, count)    \
> -for ((offset) = (dataoff) + sizeof(struct sctphdr), (count) = 0;       \
> -       (offset) < (skb)->len &&                                        \
> -       ((sch) = skb_header_pointer((skb), (offset), sizeof(_sch), &(_sch)));   \
> -       (offset) += (ntohs((sch)->length) + 3) & ~3, (count)++)
> -
> -/* Some validity checks to make sure the chunks are fine */
> -static int do_basic_checks(struct nf_conn *ct,
> -                          const struct sk_buff *skb,
> -                          unsigned int dataoff,
> -                          unsigned long *map)
> -{
> -       u_int32_t offset, count;
> -       struct sctp_chunkhdr _sch, *sch;
> -       int flag;
> -
> -       flag = 0;
> -
> -       for_each_sctp_chunk (skb, sch, _sch, offset, dataoff, count) {
> -               pr_debug("Chunk Num: %d  Type: %d\n", count, sch->type);
> -
> -               if (sch->type == SCTP_CID_INIT ||
> -                   sch->type == SCTP_CID_INIT_ACK ||
> -                   sch->type == SCTP_CID_SHUTDOWN_COMPLETE)
> -                       flag = 1;
> -
> -               /*
> -                * Cookie Ack/Echo chunks not the first OR
> -                * Init / Init Ack / Shutdown compl chunks not the only chunks
> -                * OR zero-length.
> -                */
> -               if (((sch->type == SCTP_CID_COOKIE_ACK ||
> -                     sch->type == SCTP_CID_COOKIE_ECHO ||
> -                     flag) &&
> -                    count != 0) || !sch->length) {
> -                       pr_debug("Basic checks failed\n");
> -                       return 1;
> -               }
> -
> -               if (map)
> -                       set_bit(sch->type, map);
> -       }
> -
> -       pr_debug("Basic checks passed\n");
> -       return count == 0;
> -}
> -
> -static int sctp_new_state(enum ip_conntrack_dir dir,
> -                         enum sctp_conntrack cur_state,
> -                         int chunk_type)
> -{
> -       int i;
> -
> -       pr_debug("Chunk type: %d\n", chunk_type);
> -
> -       switch (chunk_type) {
> -       case SCTP_CID_INIT:
> -               pr_debug("SCTP_CID_INIT\n");
> -               i = 0;
> -               break;
> -       case SCTP_CID_INIT_ACK:
> -               pr_debug("SCTP_CID_INIT_ACK\n");
> -               i = 1;
> -               break;
> -       case SCTP_CID_ABORT:
> -               pr_debug("SCTP_CID_ABORT\n");
> -               i = 2;
> -               break;
> -       case SCTP_CID_SHUTDOWN:
> -               pr_debug("SCTP_CID_SHUTDOWN\n");
> -               i = 3;
> -               break;
> -       case SCTP_CID_SHUTDOWN_ACK:
> -               pr_debug("SCTP_CID_SHUTDOWN_ACK\n");
> -               i = 4;
> -               break;
> -       case SCTP_CID_ERROR:
> -               pr_debug("SCTP_CID_ERROR\n");
> -               i = 5;
> -               break;
> -       case SCTP_CID_COOKIE_ECHO:
> -               pr_debug("SCTP_CID_COOKIE_ECHO\n");
> -               i = 6;
> -               break;
> -       case SCTP_CID_COOKIE_ACK:
> -               pr_debug("SCTP_CID_COOKIE_ACK\n");
> -               i = 7;
> -               break;
> -       case SCTP_CID_SHUTDOWN_COMPLETE:
> -               pr_debug("SCTP_CID_SHUTDOWN_COMPLETE\n");
> -               i = 8;
> -               break;
> -       case SCTP_CID_HEARTBEAT:
> -               pr_debug("SCTP_CID_HEARTBEAT");
> -               i = 9;
> -               break;
> -       case SCTP_CID_HEARTBEAT_ACK:
> -               pr_debug("SCTP_CID_HEARTBEAT_ACK");
> -               i = 10;
> -               break;
> -       case SCTP_CID_DATA:
> -       case SCTP_CID_SACK:
> -               pr_debug("SCTP_CID_DATA/SACK");
> -               i = 11;
> -               break;
> -       default:
> -               /* Other chunks like DATA or SACK do not change the state */
> -               pr_debug("Unknown chunk type, Will stay in %s\n",
> -                        sctp_conntrack_names[cur_state]);
> -               return cur_state;
> -       }
> -
> -       pr_debug("dir: %d   cur_state: %s  chunk_type: %d  new_state: %s\n",
> -                dir, sctp_conntrack_names[cur_state], chunk_type,
> -                sctp_conntrack_names[sctp_conntracks[dir][i][cur_state]]);
> -
> -       return sctp_conntracks[dir][i][cur_state];
> -}
> -
> -/* Don't need lock here: this conntrack not in circulation yet */
> -static noinline bool
> -sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
> -        const struct sctphdr *sh, unsigned int dataoff)
> -{
> -       enum sctp_conntrack new_state;
> -       const struct sctp_chunkhdr *sch;
> -       struct sctp_chunkhdr _sch;
> -       u32 offset, count;
> -
> -       memset(&ct->proto.sctp, 0, sizeof(ct->proto.sctp));
> -       new_state = SCTP_CONNTRACK_MAX;
> -       for_each_sctp_chunk(skb, sch, _sch, offset, dataoff, count) {
> -               new_state = sctp_new_state(IP_CT_DIR_ORIGINAL,
> -                                          SCTP_CONNTRACK_NONE, sch->type);
> -
> -               /* Invalid: delete conntrack */
> -               if (new_state == SCTP_CONNTRACK_NONE ||
> -                   new_state == SCTP_CONNTRACK_MAX) {
> -                       pr_debug("nf_conntrack_sctp: invalid new deleting.\n");
> -                       return false;
> -               }
> -
> -               /* Copy the vtag into the state info */
> -               if (sch->type == SCTP_CID_INIT) {
> -                       struct sctp_inithdr _inithdr, *ih;
> -                       /* Sec 8.5.1 (A) */
> -                       if (sh->vtag)
> -                               return false;
> -
> -                       ih = skb_header_pointer(skb, offset + sizeof(_sch),
> -                                               sizeof(_inithdr), &_inithdr);
> -                       if (!ih)
> -                               return false;
> -
> -                       pr_debug("Setting vtag %x for new conn\n",
> -                                ih->init_tag);
> -
> -                       ct->proto.sctp.vtag[IP_CT_DIR_REPLY] = ih->init_tag;
> -               } else if (sch->type == SCTP_CID_HEARTBEAT ||
> -                          sch->type == SCTP_CID_DATA ||
> -                          sch->type == SCTP_CID_SACK) {
> -                       pr_debug("Setting vtag %x for secondary conntrack\n",
> -                                sh->vtag);
> -                       ct->proto.sctp.vtag[IP_CT_DIR_ORIGINAL] = sh->vtag;
> -               } else {
> -               /* If it is a shutdown ack OOTB packet, we expect a return
> -                  shutdown complete, otherwise an ABORT Sec 8.4 (5) and (8) */
> -                       pr_debug("Setting vtag %x for new conn OOTB\n",
> -                                sh->vtag);
> -                       ct->proto.sctp.vtag[IP_CT_DIR_REPLY] = sh->vtag;
> -               }
> -
> -               ct->proto.sctp.state = SCTP_CONNTRACK_NONE;
> -       }
> -
> -       return true;
> -}
> -
>  static bool sctp_error(struct sk_buff *skb,
>                        unsigned int dataoff,
>                        const struct nf_hook_state *state)
> @@ -367,6 +82,90 @@ static bool sctp_error(struct sk_buff *skb,
>         return true;
>  }
>
> +static void sctp_new(struct nf_conn *ct,
> +                    enum ip_conntrack_info ctinfo,
> +                    u32 init_vtag,
> +                    u32 vtag,
> +                    unsigned long *map)
> +{
> +       enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
> +
> +       memset(&ct->proto.sctp, 0, sizeof(ct->proto.sctp));
> +       ct->proto.sctp.state = SCTP_CONNTRACK_OPEN_WAIT;
> +       nf_conntrack_event_cache(IPCT_PROTOINFO, ct);
> +
> +       if (test_bit(SCTP_CID_INIT, map))
> +               ct->proto.sctp.vtag[!dir] = init_vtag;
> +       else if (test_bit(SCTP_CID_SHUTDOWN_ACK, map))
> +               /* If it is a shutdown ack OOTB packet, we expect a return
> +                * shutdown complete, otherwise an ABORT Sec 8.4 (5) and (8)
> +                */
> +               ct->proto.sctp.vtag[!dir] = vtag;
> +       else
> +               ct->proto.sctp.vtag[dir] = vtag;
> +}
> +
> +static bool sctp_vtag_check(struct nf_conn *ct,
> +                           enum ip_conntrack_info ctinfo,
> +                           u32 vtag,
> +                           unsigned long *map,
> +                           unsigned long *tflags)
> +{
> +       enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
> +
> +       /* Check the verification tag (Sec 8.5) */
> +       if (!test_bit(SCTP_CID_INIT, map) &&
> +           !test_bit(SCTP_CID_SHUTDOWN_COMPLETE, map) &&
> +           !test_bit(SCTP_CID_COOKIE_ECHO, map) &&
> +           !test_bit(SCTP_CID_ABORT, map) &&
> +           !test_bit(SCTP_CID_SHUTDOWN_ACK, map) &&
> +           !test_bit(SCTP_CID_HEARTBEAT, map) &&
> +           !test_bit(SCTP_CID_HEARTBEAT_ACK, map) &&
> +           vtag != ct->proto.sctp.vtag[dir]) {
> +               return false;
> +       }
> +
> +       /* Special cases of Verification tag check (Sec 8.5.1) */
> +       if (test_bit(SCTP_CID_INIT, map)) {
> +               /* (A) vtag MUST be zero */
> +               if (vtag != 0)
> +                       return false;
> +       }
> +       if (test_bit(SCTP_CID_ABORT, map)) {
> +               /* (B) vtag MUST match own vtag if T flag is unset OR
> +                * MUST match peer's vtag if T flag is set
> +                */
> +               if ((!test_bit(SCTP_CID_ABORT, tflags) &&
> +                    vtag != ct->proto.sctp.vtag[dir]) ||
> +                   (test_bit(SCTP_CID_ABORT, tflags) &&
> +                    vtag != ct->proto.sctp.vtag[!dir]))
> +                       return false;
> +       }
> +       if (test_bit(SCTP_CID_SHUTDOWN_COMPLETE, map)) {
> +               /* (C) vtag MUST match own vtag if T flag is unset OR
> +                * MUST match peer's vtag if T flag is set
> +                */
> +               if ((!test_bit(SCTP_CID_SHUTDOWN_COMPLETE, tflags) &&
> +                    vtag != ct->proto.sctp.vtag[dir]) ||
> +                   (test_bit(SCTP_CID_SHUTDOWN_COMPLETE, tflags) &&
> +                    vtag != ct->proto.sctp.vtag[!dir]))
> +                       return false;
> +       }
> +       if (test_bit(SCTP_CID_COOKIE_ECHO, map)) {
> +               /* (D) vtag must be same as init_vtag as found in INIT_ACK */
> +               if (vtag != ct->proto.sctp.vtag[dir])
> +                       return false;
> +       }
> +
> +       return true;
> +}
> +
> +#define for_each_sctp_chunk(skb, sch, _sch, offset, dataoff)   \
> +for ((offset) = (dataoff) + sizeof(struct sctphdr);    \
> +       ((sch) = skb_header_pointer((skb), (offset), sizeof(_sch), &(_sch))) && \
> +       (sch)->length;  \
> +       (offset) += (ntohs((sch)->length) + 3) & ~3)
> +
>  /* Returns verdict for packet, or -NF_ACCEPT for invalid. */
>  int nf_conntrack_sctp_packet(struct nf_conn *ct,
>                              struct sk_buff *skb,
> @@ -374,26 +173,39 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
>                              enum ip_conntrack_info ctinfo,
>                              const struct nf_hook_state *state)
>  {
> -       enum sctp_conntrack new_state, old_state;
>         enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
> -       const struct sctphdr *sh;
> -       struct sctphdr _sctph;
> -       const struct sctp_chunkhdr *sch;
> -       struct sctp_chunkhdr _sch;
> -       u_int32_t offset, count;
> -       unsigned int *timeouts;
>         unsigned long map[256 / sizeof(unsigned long)] = { 0 };
> -       bool ignore = false;
> +       unsigned long tflags[256 / sizeof(unsigned long)] = { 0 };
> +       unsigned int *timeouts;
> +       u32 init_vtag = 0;
> +       u32 offset, count;
> +       struct sctphdr _sctph, *sctph;
> +       struct sctp_chunkhdr _sch, *sch;
>
>         if (sctp_error(skb, dataoff, state))
>                 return -NF_ACCEPT;
>
> -       sh = skb_header_pointer(skb, dataoff, sizeof(_sctph), &_sctph);
> -       if (sh == NULL)
> -               goto out;
> +       sctph = skb_header_pointer(skb, dataoff, sizeof(_sctph), &_sctph);
> +       if (!sctph)
> +               return -NF_ACCEPT;
>
> -       if (do_basic_checks(ct, skb, dataoff, map) != 0)
> -               goto out;
> +       for_each_sctp_chunk (skb, sch, _sch, offset, dataoff) {
> +               set_bit(sch->type, map);
> +               if (sch->flags & SCTP_CHUNK_FLAG_T)
> +                       set_bit(sch->type, tflags);
> +
> +               if (sch->type == SCTP_CID_INIT ||
> +                   sch->type == SCTP_CID_INIT_ACK) {
> +                       struct sctp_inithdr _inith, *inith;
> +
> +                       inith = skb_header_pointer(skb, offset + sizeof(_sch),
> +                                                  sizeof(_inith), &_inith);
> +                       if (inith)
> +                               init_vtag = inith->init_tag;
> +                       else
> +                               return -NF_ACCEPT;
> +               }
> +       }
>
>         if (!nf_ct_is_confirmed(ct)) {
>                 /* If an OOTB packet has any of these chunks discard (Sec 8.4) */
> @@ -402,167 +214,86 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
>                     test_bit(SCTP_CID_COOKIE_ACK, map))
>                         return -NF_ACCEPT;
>
> -               if (!sctp_new(ct, skb, sh, dataoff))
> -                       return -NF_ACCEPT;
> -       } else {
> -               /* Check the verification tag (Sec 8.5) */
> -               if (!test_bit(SCTP_CID_INIT, map) &&
> -                   !test_bit(SCTP_CID_SHUTDOWN_COMPLETE, map) &&
> -                   !test_bit(SCTP_CID_COOKIE_ECHO, map) &&
> -                   !test_bit(SCTP_CID_ABORT, map) &&
> -                   !test_bit(SCTP_CID_SHUTDOWN_ACK, map) &&
> -                   !test_bit(SCTP_CID_HEARTBEAT, map) &&
> -                   !test_bit(SCTP_CID_HEARTBEAT_ACK, map) &&
> -                   sh->vtag != ct->proto.sctp.vtag[dir]) {
> -                       pr_debug("Verification tag check failed\n");
> -                       goto out;
> -               }
> +               sctp_new(ct, ctinfo, init_vtag, sctph->vtag, map);
> +               goto out;
>         }
>
> -       old_state = new_state = SCTP_CONNTRACK_NONE;
> +       /* don't renew timeout on init retransmit so
> +        * port reuse by client or NAT middlebox cannot
> +        * keep entry alive indefinitely (incl. nat info).
> +        */
> +       if (test_bit(SCTP_CID_INIT, map))
> +               return NF_ACCEPT;
> +
>         spin_lock_bh(&ct->lock);
> -       for_each_sctp_chunk (skb, sch, _sch, offset, dataoff, count) {
> -               /* Special cases of Verification tag check (Sec 8.5.1) */
> -               if (sch->type == SCTP_CID_INIT) {
> -                       /* Sec 8.5.1 (A) */
> -                       if (sh->vtag != 0)
> -                               goto out_unlock;
> -               } else if (sch->type == SCTP_CID_ABORT) {
> -                       /* Sec 8.5.1 (B) */
> -                       if (sh->vtag != ct->proto.sctp.vtag[dir] &&
> -                           sh->vtag != ct->proto.sctp.vtag[!dir])
> -                               goto out_unlock;
> -               } else if (sch->type == SCTP_CID_SHUTDOWN_COMPLETE) {
> -                       /* Sec 8.5.1 (C) */
> -                       if (sh->vtag != ct->proto.sctp.vtag[dir] &&
> -                           sh->vtag != ct->proto.sctp.vtag[!dir] &&
> -                           sch->flags & SCTP_CHUNK_FLAG_T)
> -                               goto out_unlock;
> -               } else if (sch->type == SCTP_CID_COOKIE_ECHO) {
> -                       /* Sec 8.5.1 (D) */
> -                       if (sh->vtag != ct->proto.sctp.vtag[dir])
> -                               goto out_unlock;
> -               } else if (sch->type == SCTP_CID_HEARTBEAT) {
> -                       if (ct->proto.sctp.vtag[dir] == 0) {
> -                               pr_debug("Setting %d vtag %x for dir %d\n", sch->type, sh->vtag, dir);
> -                               ct->proto.sctp.vtag[dir] = sh->vtag;
> -                       } else if (sh->vtag != ct->proto.sctp.vtag[dir]) {
> -                               if (test_bit(SCTP_CID_DATA, map) || ignore)
> -                                       goto out_unlock;
> -
> -                               ct->proto.sctp.flags |= SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
> -                               ct->proto.sctp.last_dir = dir;
> -                               ignore = true;
> -                               continue;
> -                       } else if (ct->proto.sctp.flags & SCTP_FLAG_HEARTBEAT_VTAG_FAILED) {
> -                               ct->proto.sctp.flags &= ~SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
> -                       }
> -               } else if (sch->type == SCTP_CID_HEARTBEAT_ACK) {
> -                       if (ct->proto.sctp.vtag[dir] == 0) {
> -                               pr_debug("Setting vtag %x for dir %d\n",
> -                                        sh->vtag, dir);
> -                               ct->proto.sctp.vtag[dir] = sh->vtag;
> -                       } else if (sh->vtag != ct->proto.sctp.vtag[dir]) {
> -                               if (test_bit(SCTP_CID_DATA, map) || ignore)
> -                                       goto out_unlock;
> -
> -                               if ((ct->proto.sctp.flags & SCTP_FLAG_HEARTBEAT_VTAG_FAILED) == 0 ||
> -                                   ct->proto.sctp.last_dir == dir)
> -                                       goto out_unlock;
> -
> -                               ct->proto.sctp.flags &= ~SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
> -                               ct->proto.sctp.vtag[dir] = sh->vtag;
> -                               ct->proto.sctp.vtag[!dir] = 0;
> -                       } else if (ct->proto.sctp.flags & SCTP_FLAG_HEARTBEAT_VTAG_FAILED) {
> -                               ct->proto.sctp.flags &= ~SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
> -                       }
> -               } else if (sch->type == SCTP_CID_DATA || sch->type == SCTP_CID_SACK) {
> -                       if (ct->proto.sctp.vtag[dir] == 0) {
> -                               pr_debug("Setting vtag %x for dir %d\n", sh->vtag, dir);
> -                               ct->proto.sctp.vtag[dir] = sh->vtag;
> -                       }
> -               }
> +       if (!ct->proto.sctp.vtag[!dir] &&
> +           test_bit(SCTP_CID_INIT_ACK, map))
> +               ct->proto.sctp.vtag[!dir] = init_vtag;
>
> -               old_state = ct->proto.sctp.state;
> -               new_state = sctp_new_state(dir, old_state, sch->type);
> +       if (!ct->proto.sctp.vtag[dir])
> +               ct->proto.sctp.vtag[dir] = sctph->vtag;
>
> -               /* Invalid */
> -               if (new_state == SCTP_CONNTRACK_MAX) {
> -                       pr_debug("nf_conntrack_sctp: Invalid dir=%i ctype=%u "
> -                                "conntrack=%u\n",
> -                                dir, sch->type, old_state);
> -                       goto out_unlock;
> -               }
> +       /* we have seen traffic both ways, go to established */
> +       if (dir == IP_CT_DIR_REPLY &&
> +           ct->proto.sctp.state == SCTP_CONNTRACK_OPEN_WAIT) {
> +               ct->proto.sctp.state = SCTP_CONNTRACK_ESTABLISHED;
> +               nf_conntrack_event_cache(IPCT_PROTOINFO, ct);
>
> -               /* If it is an INIT or an INIT ACK note down the vtag */
> -               if (sch->type == SCTP_CID_INIT ||
> -                   sch->type == SCTP_CID_INIT_ACK) {
> -                       struct sctp_inithdr _inithdr, *ih;
> +               if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
> +                       nf_conntrack_event_cache(IPCT_ASSURED, ct);
> +       }
>
> -                       ih = skb_header_pointer(skb, offset + sizeof(_sch),
> -                                               sizeof(_inithdr), &_inithdr);
> -                       if (ih == NULL)
> +       if (test_bit(SCTP_CID_HEARTBEAT, map)) {
> +               if (sctph->vtag != ct->proto.sctp.vtag[dir]) {
> +                       if (test_bit(SCTP_CID_DATA, map))
>                                 goto out_unlock;
> -                       pr_debug("Setting vtag %x for dir %d\n",
> -                                ih->init_tag, !dir);
> -                       ct->proto.sctp.vtag[!dir] = ih->init_tag;
> -
> -                       /* don't renew timeout on init retransmit so
> -                        * port reuse by client or NAT middlebox cannot
> -                        * keep entry alive indefinitely (incl. nat info).
> -                        */
> -                       if (new_state == SCTP_CONNTRACK_CLOSED &&
> -                           old_state == SCTP_CONNTRACK_CLOSED &&
> -                           nf_ct_is_confirmed(ct))
> -                               ignore = true;
> +
> +                       ct->proto.sctp.flags |= SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
> +                       ct->proto.sctp.last_dir = dir;
> +               } else if (ct->proto.sctp.flags & SCTP_FLAG_HEARTBEAT_VTAG_FAILED) {
> +                       ct->proto.sctp.flags &= ~SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
>                 }
> +       }
> +       if (test_bit(SCTP_CID_HEARTBEAT_ACK, map)) {
> +               if (sctph->vtag != ct->proto.sctp.vtag[dir]) {
> +                       if (test_bit(SCTP_CID_DATA, map))
> +                               goto out_unlock;
> +
> +                       if ((ct->proto.sctp.flags & SCTP_FLAG_HEARTBEAT_VTAG_FAILED) == 0 ||
> +                           ct->proto.sctp.last_dir == dir)
> +                               goto out_unlock;
>
> -               ct->proto.sctp.state = new_state;
> -               if (old_state != new_state)
> -                       nf_conntrack_event_cache(IPCT_PROTOINFO, ct);
> +                       ct->proto.sctp.flags &= ~SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
> +                       ct->proto.sctp.vtag[dir] = sctph->vtag;
> +                       ct->proto.sctp.vtag[!dir] = 0;
> +               } else if (ct->proto.sctp.flags & SCTP_FLAG_HEARTBEAT_VTAG_FAILED) {
> +                       ct->proto.sctp.flags &= ~SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
> +               }
>         }
>         spin_unlock_bh(&ct->lock);
>
> -       /* allow but do not refresh timeout */
> -       if (ignore)
> -               return NF_ACCEPT;
> +       if (!sctp_vtag_check(ct, ctinfo, sctph->vtag, map, tflags)) {
> +               nf_ct_l4proto_log_invalid(skb, ct, state,
> +                                         "verification tag check failed %x vs (%x: dir %d) and (%x: dir %d)",
> +                                         sctph->vtag, ct->proto.sctp.vtag[dir], dir,
> +                                         ct->proto.sctp.vtag[!dir], !dir);
> +               return -NF_ACCEPT;
> +       }
>
> +out:
>         timeouts = nf_ct_timeout_lookup(ct);
>         if (!timeouts)
>                 timeouts = nf_sctp_pernet(nf_ct_net(ct))->timeouts;
>
> -       nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[new_state]);
> -
> -       if (old_state == SCTP_CONNTRACK_COOKIE_ECHOED &&
> -           dir == IP_CT_DIR_REPLY &&
> -           new_state == SCTP_CONNTRACK_ESTABLISHED) {
> -               pr_debug("Setting assured bit\n");
> -               set_bit(IPS_ASSURED_BIT, &ct->status);
> -               nf_conntrack_event_cache(IPCT_ASSURED, ct);
> -       }
> +       nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[ct->proto.sctp.state]);
>
>         return NF_ACCEPT;
>
>  out_unlock:
>         spin_unlock_bh(&ct->lock);
> -out:
>         return -NF_ACCEPT;
>  }
>
> -static bool sctp_can_early_drop(const struct nf_conn *ct)
> -{
> -       switch (ct->proto.sctp.state) {
> -       case SCTP_CONNTRACK_SHUTDOWN_SENT:
> -       case SCTP_CONNTRACK_SHUTDOWN_RECD:
> -       case SCTP_CONNTRACK_SHUTDOWN_ACK_SENT:
> -               return true;
> -       default:
> -               break;
> -       }
> -
> -       return false;
> -}
> -
>  #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
>
>  #include <linux/netfilter/nfnetlink.h>
> @@ -670,7 +401,7 @@ static int sctp_timeout_nlattr_to_obj(struct nlattr *tb[],
>                 }
>         }
>
> -       timeouts[CTA_TIMEOUT_SCTP_UNSPEC] = timeouts[CTA_TIMEOUT_SCTP_CLOSED];
> +       timeouts[CTA_TIMEOUT_SCTP_UNSPEC] = timeouts[CTA_TIMEOUT_SCTP_OPEN_WAIT];
>         return 0;
>  }
>
> @@ -692,16 +423,8 @@ sctp_timeout_obj_to_nlattr(struct sk_buff *skb, const void *data)
>
>  static const struct nla_policy
>  sctp_timeout_nla_policy[CTA_TIMEOUT_SCTP_MAX+1] = {
> -       [CTA_TIMEOUT_SCTP_CLOSED]               = { .type = NLA_U32 },
> -       [CTA_TIMEOUT_SCTP_COOKIE_WAIT]          = { .type = NLA_U32 },
> -       [CTA_TIMEOUT_SCTP_COOKIE_ECHOED]        = { .type = NLA_U32 },
> +       [CTA_TIMEOUT_SCTP_OPEN_WAIT]            = { .type = NLA_U32 },
>         [CTA_TIMEOUT_SCTP_ESTABLISHED]          = { .type = NLA_U32 },
> -       [CTA_TIMEOUT_SCTP_SHUTDOWN_SENT]        = { .type = NLA_U32 },
> -       [CTA_TIMEOUT_SCTP_SHUTDOWN_RECD]        = { .type = NLA_U32 },
> -       [CTA_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT]    = { .type = NLA_U32 },
> -       [CTA_TIMEOUT_SCTP_HEARTBEAT_SENT]       = { .type = NLA_U32 },
> -       [CTA_TIMEOUT_SCTP_HEARTBEAT_ACKED]      = { .type = NLA_U32 },
> -       [CTA_TIMEOUT_SCTP_DATA_SENT]            = { .type = NLA_U32 },
>  };
>  #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
>
> @@ -716,7 +439,7 @@ void nf_conntrack_sctp_init_net(struct net *net)
>         /* timeouts[0] is unused, init it so ->timeouts[0] contains
>          * 'new' timeout, like udp or icmp.
>          */
> -       sn->timeouts[0] = sctp_timeouts[SCTP_CONNTRACK_CLOSED];
> +       sn->timeouts[0] = sctp_timeouts[SCTP_CONNTRACK_OPEN_WAIT];
>  }
>
>  const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp = {
> @@ -724,7 +447,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp = {
>  #ifdef CONFIG_NF_CONNTRACK_PROCFS
>         .print_conntrack        = sctp_print_conntrack,
>  #endif
> -       .can_early_drop         = sctp_can_early_drop,
>  #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
>         .nlattr_size            = SCTP_NLATTR_SIZE,
>         .to_nlattr              = sctp_to_nlattr,
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index 0250725e38a4..07da9db31783 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -593,16 +593,8 @@ enum nf_ct_sysctl_index {
>         NF_SYSCTL_CT_PROTO_TIMEOUT_ICMP,
>         NF_SYSCTL_CT_PROTO_TIMEOUT_ICMPV6,
>  #ifdef CONFIG_NF_CT_PROTO_SCTP
> -       NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_CLOSED,
> -       NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_COOKIE_WAIT,
> -       NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_COOKIE_ECHOED,
> +       NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_OPEN_WAIT,
>         NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_ESTABLISHED,
> -       NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_SENT,
> -       NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_RECD,
> -       NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT,
> -       NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_SENT,
> -       NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_ACKED,
> -       NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_DATA_SENT,
>  #endif
>  #ifdef CONFIG_NF_CT_PROTO_DCCP
>         NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_REQUEST,
> @@ -839,20 +831,8 @@ static struct ctl_table nf_ct_sysctl_table[] = {
>                 .proc_handler   = proc_dointvec_jiffies,
>         },
>  #ifdef CONFIG_NF_CT_PROTO_SCTP
> -       [NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_CLOSED] = {
> -               .procname       = "nf_conntrack_sctp_timeout_closed",
> -               .maxlen         = sizeof(unsigned int),
> -               .mode           = 0644,
> -               .proc_handler   = proc_dointvec_jiffies,
> -       },
> -       [NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_COOKIE_WAIT] = {
> -               .procname       = "nf_conntrack_sctp_timeout_cookie_wait",
> -               .maxlen         = sizeof(unsigned int),
> -               .mode           = 0644,
> -               .proc_handler   = proc_dointvec_jiffies,
> -       },
> -       [NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_COOKIE_ECHOED] = {
> -               .procname       = "nf_conntrack_sctp_timeout_cookie_echoed",
> +       [NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_OPEN_WAIT] = {
> +               .procname       = "nf_conntrack_sctp_timeout_open_wait",
>                 .maxlen         = sizeof(unsigned int),
>                 .mode           = 0644,
>                 .proc_handler   = proc_dointvec_jiffies,
> @@ -863,42 +843,6 @@ static struct ctl_table nf_ct_sysctl_table[] = {
>                 .mode           = 0644,
>                 .proc_handler   = proc_dointvec_jiffies,
>         },
> -       [NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_SENT] = {
> -               .procname       = "nf_conntrack_sctp_timeout_shutdown_sent",
> -               .maxlen         = sizeof(unsigned int),
> -               .mode           = 0644,
> -               .proc_handler   = proc_dointvec_jiffies,
> -       },
> -       [NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_RECD] = {
> -               .procname       = "nf_conntrack_sctp_timeout_shutdown_recd",
> -               .maxlen         = sizeof(unsigned int),
> -               .mode           = 0644,
> -               .proc_handler   = proc_dointvec_jiffies,
> -       },
> -       [NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT] = {
> -               .procname       = "nf_conntrack_sctp_timeout_shutdown_ack_sent",
> -               .maxlen         = sizeof(unsigned int),
> -               .mode           = 0644,
> -               .proc_handler   = proc_dointvec_jiffies,
> -       },
> -       [NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_SENT] = {
> -               .procname       = "nf_conntrack_sctp_timeout_heartbeat_sent",
> -               .maxlen         = sizeof(unsigned int),
> -               .mode           = 0644,
> -               .proc_handler   = proc_dointvec_jiffies,
> -       },
> -       [NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_ACKED] = {
> -               .procname       = "nf_conntrack_sctp_timeout_heartbeat_acked",
> -               .maxlen         = sizeof(unsigned int),
> -               .mode           = 0644,
> -               .proc_handler   = proc_dointvec_jiffies,
> -       },
> -       [NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_DATA_SENT] = {
> -               .procname       = "nf_conntrack_sctp_timeout_data_sent",
> -               .maxlen         = sizeof(unsigned int),
> -               .mode           = 0644,
> -               .proc_handler   = proc_dointvec_jiffies,
> -       },
>  #endif
>  #ifdef CONFIG_NF_CT_PROTO_DCCP
>         [NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_REQUEST] = {
> @@ -1034,16 +978,8 @@ static void nf_conntrack_standalone_init_sctp_sysctl(struct net *net,
>         table[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_ ## XNAME].data = \
>                         &(sn)->timeouts[SCTP_CONNTRACK_ ## XNAME]
>
> -       XASSIGN(CLOSED, sn);
> -       XASSIGN(COOKIE_WAIT, sn);
> -       XASSIGN(COOKIE_ECHOED, sn);
> +       XASSIGN(OPEN_WAIT, sn);
>         XASSIGN(ESTABLISHED, sn);
> -       XASSIGN(SHUTDOWN_SENT, sn);
> -       XASSIGN(SHUTDOWN_RECD, sn);
> -       XASSIGN(SHUTDOWN_ACK_SENT, sn);
> -       XASSIGN(HEARTBEAT_SENT, sn);
> -       XASSIGN(HEARTBEAT_ACKED, sn);
> -       XASSIGN(DATA_SENT, sn);
>  #undef XASSIGN
>  #endif
>  }
> --
> 2.34.1
>

--000000000000d2cb3005f19d720a
Content-Type: text/x-sh; charset="US-ASCII"; name="proto_nat.sh"
Content-Disposition: attachment; filename="proto_nat.sh"
Content-Transfer-Encoding: base64
Content-ID: <f_lckwqioa0>
X-Attachment-Id: f_lckwqioa0

IyEvYmluL2Jhc2gKIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMAojCiMgVGVzdGlu
ZyBGb3IgVENQL1VEUC9TQ1RQKDQvNikgTkFULgojIFRPUE86IENMSUVOVF9OUyAobGluazApPC0t
LT4obGluazEpIEhPU1QvUk9VVEVSIChsaW5rMik8LS0tPihsaW5rMykgU0VSVkVSX05TCgpDTElF
TlRfTlM9ImNsaWVudC1ucyIKQ0xJRU5UX0lQND0iMTk4LjUxLjEwMC4xIgpDTElFTlRfR1c0PSIx
OTguNTEuMTAwLjIiCkNMSUVOVF9JUDY9IjIwMDE6ZGI4OjE6OjEiCkNMSUVOVF9HVzY9IjIwMDE6
ZGI4OjE6OjIiCgpTRVJWRVJfTlM9InNlcnZlci1ucyIKU0VSVkVSX0lQND0iMjAzLjAuMTEzLjEi
ClNFUlZFUl9HVzQ9IjIwMy4wLjExMy4yIgpTRVJWRVJfSVA2PSIyMDAxOmRiODoyOjoxIgpTRVJW
RVJfR1c2PSIyMDAxOmRiODoyOjoyIgoKc2V0dXAoKSB7CglpcCBuZXRucyBhZGQgJENMSUVOVF9O
UwoJaXAgbmV0bnMgYWRkICRTRVJWRVJfTlMKCWlwIGxpbmsgYWRkIGxpbmsxIHR5cGUgdmV0aCBw
ZWVyIG5hbWUgbGluazAgbmV0bnMgJENMSUVOVF9OUwoJaXAgbGluayBhZGQgbGluazIgdHlwZSB2
ZXRoIHBlZXIgbmFtZSBsaW5rMyBuZXRucyAkU0VSVkVSX05TCgoJaXAgbmV0IGV4ZWMgJENMSUVO
VF9OUyBpcCBsaW5rIHNldCBsaW5rMCB1cAoJaXAgbmV0IGV4ZWMgJENMSUVOVF9OUyBpcCBhZGRy
IGFkZCAkQ0xJRU5UX0lQNC8yNCBkZXYgbGluazAKCWlwIG5ldCBleGVjICRDTElFTlRfTlMgaXAg
YWRkciBhZGQgJENMSUVOVF9JUDYvNjQgZGV2IGxpbmswIG5vZGFkCglpcCBuZXQgZXhlYyAkQ0xJ
RU5UX05TIGlwIHJvdXRlIGFkZCAkU0VSVkVSX0lQNCBkZXYgbGluazAgdmlhICRDTElFTlRfR1c0
CglpcCBuZXQgZXhlYyAkQ0xJRU5UX05TIGlwIHJvdXRlIGFkZCAkU0VSVkVSX0lQNiBkZXYgbGlu
azAgdmlhICRDTElFTlRfR1c2CgoJaXAgbGluayBzZXQgbGluazEgdXAKCWlwIGxpbmsgc2V0IGxp
bmsyIHVwCglpcCBhZGRyIGFkZCAkQ0xJRU5UX0dXNC8yNCBkZXYgbGluazEKCWlwIGFkZHIgYWRk
ICRDTElFTlRfR1c2LzY0IGRldiBsaW5rMSBub2RhZAoJaXAgYWRkciBhZGQgJFNFUlZFUl9HVzQv
MjQgZGV2IGxpbmsyCglpcCBhZGRyIGFkZCAkU0VSVkVSX0dXNi82NCBkZXYgbGluazIgbm9kYWQK
CWlwdGFibGVzIC10IG5hdCAtQSBQT1NUUk9VVElORyAtbyBsaW5rMiAtaiBNQVNRVUVSQURFCglp
cDZ0YWJsZXMgLXQgbmF0IC1BIFBPU1RST1VUSU5HIC1vIGxpbmsyIC1qIE1BU1FVRVJBREUKCglp
cCBuZXQgZXhlYyAkU0VSVkVSX05TIGlwIGxpbmsgc2V0IGxpbmszIHVwCglpcCBuZXQgZXhlYyAk
U0VSVkVSX05TIGlwIGFkZHIgYWRkICRTRVJWRVJfSVA0LzI0IGRldiBsaW5rMwoJaXAgbmV0IGV4
ZWMgJFNFUlZFUl9OUyBpcCBhZGRyIGFkZCAkU0VSVkVSX0lQNi82NCBkZXYgbGluazMgbm9kYWQK
CglJUDRfRldEPWBjYXQgL3Byb2Mvc3lzL25ldC9pcHY0L2lwX2ZvcndhcmRgCglJUDZfRldEPWBj
YXQgL3Byb2Mvc3lzL25ldC9pcHY2L2NvbmYvYWxsL2ZvcndhcmRpbmdgCglzeXNjdGwgLXcgbmV0
LmlwdjQuaXBfZm9yd2FyZD0xIDI+JjEgPi9kZXYvbnVsbAoJc3lzY3RsIC13IG5ldC5pcHY2LmNv
bmYuYWxsLmZvcndhcmRpbmc9MSAyPiYxID4vZGV2L251bGwKCW1vZHByb2JlIHNjdHAKfQoKY2xl
YW51cCgpIHsKCXN5c2N0bCAtdyBuZXQuaXB2NC5pcF9mb3J3YXJkPSRJUDRfRldEIDI+JjEgPi9k
ZXYvbnVsbAoJc3lzY3RsIC13IG5ldC5pcHY2LmNvbmYuYWxsLmZvcndhcmRpbmc9JElQNl9GV0Qg
Mj4mMSA+L2Rldi9udWxsCglpcCBsaW5rIGRlbCBsaW5rMQoJaXAgbGluayBkZWwgbGluazIKCWlw
IG5ldG5zIGRlbCAiJENMSUVOVF9OUyIKCWlwIG5ldG5zIGRlbCAiJFNFUlZFUl9OUyIKfQoKdGVz
dHVwKCkgewoJbG9jYWwgaXBhZGRyPSIkMSIKCWxvY2FsIHByb3RvPSIkMiIKCglpcCBuZXQgZXhl
YyAkU0VSVkVSX05TIG5jIC1sICRwcm90byAtcCAxMjM0IDI+JjEgPi9kZXYvbnVsbCAmCglkaXNv
d24KCWVjaG8gLW4gIm1zZzEiIHwgaXAgbmV0IGV4ZWMgJENMSUVOVF9OUyBuYyAkaXBhZGRyIDEy
MzQgLXAgNDMyMSAkcHJvdG8KCglpcCBuZXQgZXhlYyAkU0VSVkVSX05TIG5jIC1sICRwcm90byAt
cCAxMjM0IDI+JjEgPi9kZXYvbnVsbCAmCglkaXNvd24KCWVjaG8gLW4gIm1zZzIiIHwgaXAgbmV0
IGV4ZWMgJENMSUVOVF9OUyBuYyAkaXBhZGRyIDEyMzQgLXAgNDMyMSAkcHJvdG8KCglSRVQ9JD8K
CWlwIG5ldCBleGVjICRTRVJWRVJfTlMgcGtpbGwgbmMKCXJldHVybiAkUkVUCn0KCmlmICEgbmMg
LS12ZXJzaW9uICY+IC9kZXYvbnVsbDsgdGhlbgoJZWNobyAiU0tJUDogQ291bGQgbm90IHJ1biB0
ZXN0IHdpdGhvdXQgbmMgdG9vbCIKCWV4aXQgNApmaQoKdHJhcCBjbGVhbnVwIEVYSVQKc2V0dXAg
JiYKdGVzdHVwICRTRVJWRVJfSVA0ICYmIGVjaG8gIlRDUDQgTkFUOiBQQVNTIiAmJgp0ZXN0dXAg
JFNFUlZFUl9JUDYgJiYgZWNobyAiVENQNiBOQVQ6IFBBU1MiICYmCnRlc3R1cCAkU0VSVkVSX0lQ
NCAiLS11ZHAiICYmIGVjaG8gIlVEUDQgTkFUOiBQQVNTIiAmJgp0ZXN0dXAgJFNFUlZFUl9JUDYg
Ii0tdWRwIiAmJiBlY2hvICJVRFA2IE5BVDogUEFTUyIgJiYKdGVzdHVwICRTRVJWRVJfSVA0ICIt
LXNjdHAiICYmIGVjaG8gIlNDVFA0IE5BVDogUEFTUyIgJiYKdGVzdHVwICRTRVJWRVJfSVA2ICIt
LXNjdHAiICYmIGVjaG8gIlNDVFA2IE5BVDogUEFTUyIKZXhpdCAkPwo=
--000000000000d2cb3005f19d720a--

