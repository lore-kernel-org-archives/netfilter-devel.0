From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: [PATCH 05/13] Handle TCP SYN+ACK/ACK/RST transparency
Date: Sun, 30 Sep 2007 23:58:07 +0200
Message-ID: <200709302358.08166@nessa>
References: <20070930205141.10969.27205.stgit@nessa.odu> <20070930205233.10969.32752.stgit@nessa.odu> <Pine.LNX.4.64.0709302344450.7130@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from centaur.sch.bme.hu ([152.66.208.5]:53296 "EHLO
	centaur.sch.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbXI3V6I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 17:58:08 -0400
In-Reply-To: <Pine.LNX.4.64.0709302344450.7130@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Jan,

On Sunday 30 September 2007, Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>
> ---
>  net/dccp/dccp.h      |    3 ++-
>  net/dccp/minisocks.c |    3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> Index: linux-2.6.22.1/net/dccp/dccp.h
> ===================================================================
> --- linux-2.6.22.1.orig/net/dccp/dccp.h
> +++ linux-2.6.22.1/net/dccp/dccp.h
> @@ -209,7 +209,8 @@ extern int  dccp_retransmit_skb(struct s
>
>  extern void dccp_send_ack(struct sock *sk);
>  extern void dccp_send_delayed_ack(struct sock *sk);
> -extern void dccp_reqsk_send_ack(struct sk_buff *sk, struct
> request_sock *rsk); +extern void dccp_reqsk_send_ack(struct sk_buff
> *sk, struct request_sock *rsk, +	int reply_flags);
>
>  extern void dccp_send_sync(struct sock *sk, const u64 seq,
>  			   const enum dccp_pkt_type pkt_type);
> Index: linux-2.6.22.1/net/dccp/minisocks.c
> ===================================================================
> --- linux-2.6.22.1.orig/net/dccp/minisocks.c
> +++ linux-2.6.22.1/net/dccp/minisocks.c
> @@ -285,7 +285,8 @@ int dccp_child_process(struct sock *pare
>
>  EXPORT_SYMBOL_GPL(dccp_child_process);
>
> -void dccp_reqsk_send_ack(struct sk_buff *skb, struct request_sock
> *rsk) +void dccp_reqsk_send_ack(struct sk_buff *skb, struct
> request_sock *rsk, +    int reply_flags)
>  {
>  	DCCP_BUG("DCCP-ACK packets are never sent in LISTEN/RESPOND state");
>  }

Yes, this was missing. Thanks.

-- 
 KOVACS Krisztian
