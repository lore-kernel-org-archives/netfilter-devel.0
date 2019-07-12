Return-Path: <SRS0=tLP1=VJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AF2AC742B2
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Jul 2019 10:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1580208E4
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Jul 2019 10:50:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="AXT6L1x5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbfGLKul (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Jul 2019 06:50:41 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:46743 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbfGLKul (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Jul 2019 06:50:41 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 347BCCC010F;
        Fri, 12 Jul 2019 12:50:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1562928635; x=1564743036; bh=+PdSXXhgr/
        WayO4c6IOun8Jh2y8N2m6I+Vtz4VeyXPs=; b=AXT6L1x5xdgwwcIItuTupd0FV6
        7INPFRVoxvC/lduha/zSsZ0u6cWYTdMl+CW301wrfGoOF8OdwSzOCrstOyhOwBCe
        iI6GU1dO3hcKcLe5lYAnGjwHF2uDUZYtwzxBNf7N6jytiP8itBls0Yxvyl+hh6sO
        G3yVNe1kzgiZXFTio=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri, 12 Jul 2019 12:50:35 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id CD11DCC010E;
        Fri, 12 Jul 2019 12:50:35 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 9F7EF21CBA; Fri, 12 Jul 2019 12:50:35 +0200 (CEST)
Date:   Fri, 12 Jul 2019 12:50:35 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     Florian Westphal <fw@strlen.de>
cc:     netfilter-devel@vger.kernel.org,
        Jakub Jankowski <shasta@toxcorp.com>
Subject: Re: [PATCH nf] netfilter: conntrack: always store window size
 un-scaled
In-Reply-To: <20190711222905.22000-1-fw@strlen.de>
Message-ID: <alpine.DEB.2.20.1907121249380.27973@blackhole.kfki.hu>
References: <20190711222905.22000-1-fw@strlen.de>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 12 Jul 2019, Florian Westphal wrote:

> Jakub Jankowski reported following oddity:
> 
> After 3 way handshake completes, timeout of new connection is set to
> max_retrans (300s) instead of established (5 days).
> 
> shortened excerpt from pcap provided:
> 25.070622 IP (flags [DF], proto TCP (6), length 52)
> 10.8.5.4.1025 > 10.8.1.2.80: Flags [S], seq 11, win 64240, [wscale 8]
> 26.070462 IP (flags [DF], proto TCP (6), length 48)
> 10.8.1.2.80 > 10.8.5.4.1025: Flags [S.], seq 82, ack 12, win 65535, [wscale 3]
> 27.070449 IP (flags [DF], proto TCP (6), length 40)
> 10.8.5.4.1025 > 10.8.1.2.80: Flags [.], ack 83, win 512, length 0
> 
> Turns out the last_win is of u16 type, but we store the scaled value:
> 512 << 8 (== 0x20000) becomes 0 window.
> 
> The Fixes tag is not correct, as the bug has existed forever, but
> without that change all that this causes might cause is to mistake a
> window update (to-nonzero-from-zero) for a retransmit.
> 
> Fixes: fbcd253d2448b8 ("netfilter: conntrack: lower timeout to RETRANS seconds if window is 0")
> Reported-by: Jakub Jankowski <shasta@toxcorp.com>
> Tested-by: Jakub Jankowski <shasta@toxcorp.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

It was a nice report and catch!

Best regards,
Jozsef

> ---
>  net/netfilter/nf_conntrack_proto_tcp.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index 7ba01d8ee165..9fe1d5e46249 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -475,6 +475,7 @@ static bool tcp_in_window(const struct nf_conn *ct,
>  	struct ip_ct_tcp_state *receiver = &state->seen[!dir];
>  	const struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
>  	__u32 seq, ack, sack, end, win, swin;
> +	u16 win_raw;
>  	s32 receiver_offset;
>  	bool res, in_recv_win;
>  
> @@ -483,7 +484,8 @@ static bool tcp_in_window(const struct nf_conn *ct,
>  	 */
>  	seq = ntohl(tcph->seq);
>  	ack = sack = ntohl(tcph->ack_seq);
> -	win = ntohs(tcph->window);
> +	win_raw = ntohs(tcph->window);
> +	win = win_raw;
>  	end = segment_seq_plus_len(seq, skb->len, dataoff, tcph);
>  
>  	if (receiver->flags & IP_CT_TCP_FLAG_SACK_PERM)
> @@ -658,14 +660,14 @@ static bool tcp_in_window(const struct nf_conn *ct,
>  			    && state->last_seq == seq
>  			    && state->last_ack == ack
>  			    && state->last_end == end
> -			    && state->last_win == win)
> +			    && state->last_win == win_raw)
>  				state->retrans++;
>  			else {
>  				state->last_dir = dir;
>  				state->last_seq = seq;
>  				state->last_ack = ack;
>  				state->last_end = end;
> -				state->last_win = win;
> +				state->last_win = win_raw;
>  				state->retrans = 0;
>  			}
>  		}
> -- 
> 2.21.0
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
