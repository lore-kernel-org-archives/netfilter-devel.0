Return-Path: <SRS0=IQIq=VI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1619C74A52
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Jul 2019 12:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F2B421019
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Jul 2019 12:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbfGKMwi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Jul 2019 08:52:38 -0400
Received: from kich.slackware.pl ([193.218.152.244]:60124 "EHLO
        kich.slackware.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbfGKMwi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Jul 2019 08:52:38 -0400
Received: from kich.toxcorp.com (kich.toxcorp.com [193.218.152.244])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: shasta@toxcorp.com)
        by kich.slackware.pl (Postfix) with ESMTPSA id 7CAF2C0;
        Thu, 11 Jul 2019 14:52:36 +0200 (CEST)
Date:   Thu, 11 Jul 2019 14:52:36 +0200 (CEST)
From:   Jakub Jankowski <shasta@toxcorp.com>
To:     Florian Westphal <fw@strlen.de>
cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter@vger.kernel.org, mhemsley@open-systems.com,
        netfilter-devel@vger.kernel.org
Subject: Re: 3-way handshake sets conntrack timeout to max_retrans
In-Reply-To: <20190711120800.nxmib65hl5blorxy@breakpoint.cc>
Message-ID: <alpine.LNX.2.21.1907111444480.26040@kich.toxcorp.com>
References: <alpine.LNX.2.21.1907100147540.26040@kich.toxcorp.com> <alpine.DEB.2.20.1907101242560.17522@blackhole.kfki.hu> <alpine.LNX.2.21.1907101251090.26040@kich.toxcorp.com> <alpine.DEB.2.20.1907111056480.22623@blackhole.kfki.hu>
 <alpine.LNX.2.21.1907111126240.26040@kich.toxcorp.com> <20190711120800.nxmib65hl5blorxy@breakpoint.cc>
User-Agent: Alpine 2.21 (LNX 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2019-07-11, Florian Westphal wrote:

> Can you try this fix?
>
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -472,6 +472,7 @@ static bool tcp_in_window(const struct nf_conn *ct,
> 	struct ip_ct_tcp_state *receiver = &state->seen[!dir];
> 	const struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
> 	__u32 seq, ack, sack, end, win, swin;
> +	u16 win_raw;
> 	s32 receiver_offset;
> 	bool res, in_recv_win;
>
> @@ -480,7 +481,8 @@ static bool tcp_in_window(const struct nf_conn *ct,
> 	 */
> 	seq = ntohl(tcph->seq);
> 	ack = sack = ntohl(tcph->ack_seq);
> -	win = ntohs(tcph->window);
> +	win_raw = ntohs(tcph->window);
> +	win = win_raw;
> 	end = segment_seq_plus_len(seq, skb->len, dataoff, tcph);
>
> 	if (receiver->flags & IP_CT_TCP_FLAG_SACK_PERM)
> @@ -655,14 +657,14 @@ static bool tcp_in_window(const struct nf_conn *ct,
> 			    && state->last_seq == seq
> 			    && state->last_ack == ack
> 			    && state->last_end == end
> -			    && state->last_win == win)
> +			    && state->last_win == win_raw)
> 				state->retrans++;
> 			else {
> 				state->last_dir = dir;
> 				state->last_seq = seq;
> 				state->last_ack = ack;
> 				state->last_end = end;
> -				state->last_win = win;
> +				state->last_win = win_raw;
> 				state->retrans = 0;
> 			}
> 		}

Thanks for the quick turnaround, Florian!

I can confirm this indeed fixes my test case, I now get the expected
  [UPDATE] tcp      6 432000 ESTABLISHED src=10.88.15.142 dst=10.88.1.2 
sport=51451 dport=3230 src=10.88.1.2 dst=10.88.15.142 sport=3230 
dport=51451 [ASSURED]

If that's going to be the official fix, feel free to add
Tested-By: Jakub Jankowski <shasta@toxcorp.com>


Regards,
  Jakub.


-- 
Jakub Jankowski|shasta@toxcorp.com|https://toxcorp.com/
