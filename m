From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter conntrack helper: nf_ct_h323: fix bug in
 rtcp natting
Date: Tue, 22 May 2012 08:28:21 +0200
Message-ID: <1337668101.3361.54.camel@edumazet-glaptop>
References: <4FBB2B7B.6060907@elitecore.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: 'Patrick McHardy' <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Jagdish Motwani <jagdish.motwani@elitecore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33692 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab2EVG20 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 May 2012 02:28:26 -0400
Received: by bkcji2 with SMTP id ji2so4611851bkc.19
        for <netfilter-devel@vger.kernel.org>; Mon, 21 May 2012 23:28:25 -0700 (PDT)
In-Reply-To: <4FBB2B7B.6060907@elitecore.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2012-05-22 at 11:30 +0530, Jagdish Motwani wrote:
> The nat_rtp_rtcp hook takes two separate parameters port and rtp_port.
> 
> port is expected to be the real h245 address(found inside the packet).
> rtp_port is the even number closest to port  (RTP ports are even and 
> RTCP ports are odd)
> 
> However currently, both port and rtp_port are having same value(both are 
> rounded to nearest even numbers).
> 
> This works well in case of openlogicalchannel with media (RTP/even) port.
> 
> But in case of openlogicalchannel for media control (RTCP/odd) port, 
> h245 address in the packet is wrongly modified to have an even port.
> 
> I am attaching a pcap demonstrating the problem, for any further analysis.
> 
> This behavior was introduced around v2.6.19 while rewriting the helper.
> 
> 
> 
> Signed-off-by: Jagdish Motwani <jagdish.motwani@elitecore.com>
> Signed-off-by: Sanket Shah <sanket.shah@elitecore.com>
> 
> --
> diff --git a/net/netfilter/nf_conntrack_h323_main.c 
> b/net/netfilter/nf_conntrack_h323_main.c
> index 46d69d7..7f0de36 100644
> --- a/net/netfilter/nf_conntrack_h323_main.c
> +++ b/net/netfilter/nf_conntrack_h323_main.c
> @@ -270,9 +270,8 @@ static int expect_rtp_rtcp(struct sk_buff *skb, 
> struct nf_conn *ct,
>                  return 0;
> 
>          /* RTP port is even */
> -       port &= htons(~1);
> -       rtp_port = port;
> -       rtcp_port = htons(ntohs(port) + 1);
> +       rtp_port = port & htons(~1);
> +       rtcp_port = htons(ntohs(rtp_port) + 1);

seems better to use :

rtp_port = port & ~htons(1);
rtcp_port = port | htons(1);



