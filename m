Return-Path: <SRS0=WUGc=VY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 712ABC7618B
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Jul 2019 12:15:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 504282070B
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Jul 2019 12:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbfG0MPc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 27 Jul 2019 08:15:32 -0400
Received: from mail.thelounge.net ([91.118.73.15]:52293 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfG0MPc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 27 Jul 2019 08:15:32 -0400
Received: from srv-rhsoft.rhsoft.net  (Authenticated sender: h.reindl@thelounge.net) by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 45wlJw59xSzXPv;
        Sat, 27 Jul 2019 14:15:28 +0200 (CEST)
Subject: Re: [PATCH nf] netfilter: conntrack: always store window size
 un-scaled
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc:     Jakub Jankowski <shasta@toxcorp.com>
References: <20190711222905.22000-1-fw@strlen.de>
From:   Reindl Harald <h.reindl@thelounge.net>
Openpgp: id=9D2B46CDBC140A36753AE4D733174D5A5892B7B8;
 url=https://arrakis-tls.thelounge.net/gpg/h.reindl_thelounge.net.pub.txt
Organization: the lounge interactive design
Message-ID: <7d4a847d-5e8e-b5a1-0324-85f3b82f60fd@thelounge.net>
Date:   Sat, 27 Jul 2019 14:15:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190711222905.22000-1-fw@strlen.de>
Content-Type: text/plain; charset=utf-8
Content-Language: de-CH
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

this seemed to be fixed in 5.1.19 but not announced in
https://cdn.kernel.org/pub/linux/kernel/v5.x/ChangeLog-5.1.19 and after
update to 5.1.20 last night the freezes of a ssh-tunneled vnc session
are starting again without exclude "lo" while the session was stable 3 days

see topic "Connection timeouts due to INVALID state rule"

Am 12.07.19 um 00:29 schrieb Florian Westphal:
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
> 
