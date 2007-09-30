From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: [PATCH 05/13] Handle TCP SYN+ACK/ACK/RST transparency
Date: Sun, 30 Sep 2007 23:59:38 +0200
Message-ID: <200709302359.38311@nessa>
References: <20070930205141.10969.27205.stgit@nessa.odu> <Pine.LNX.4.64.0709302344450.7130@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0709302345440.7130@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from centaur.sch.bme.hu ([152.66.208.5]:53302 "EHLO
	centaur.sch.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbXI3V7f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 17:59:35 -0400
In-Reply-To: <Pine.LNX.4.64.0709302345440.7130@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Jan,

On Sunday 30 September 2007, Jan Engelhardt wrote:
> part 2/2.
>
> >Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>
> ---
>  net/ipv6/tcp_ipv6.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> Index: linux-2.6.22.3/net/ipv6/tcp_ipv6.c
> ===================================================================
> --- linux-2.6.22.3.orig/net/ipv6/tcp_ipv6.c
> +++ linux-2.6.22.3/net/ipv6/tcp_ipv6.c
> @@ -73,7 +73,7 @@
>  static struct socket *tcp6_socket;
>
>  static void	tcp_v6_send_reset(struct sock *sk, struct sk_buff *skb);
> -static void	tcp_v6_reqsk_send_ack(struct sk_buff *skb, struct
> request_sock *req); +static void	tcp_v6_reqsk_send_ack(struct sk_buff
> *skb, struct request_sock *req, int); static
> void	tcp_v6_send_check(struct sock *sk, int len,
>  				  struct sk_buff *skb);
>
> @@ -1195,7 +1195,7 @@ static void tcp_v6_timewait_ack(struct s
>  	inet_twsk_put(tw);
>  }
>
> -static void tcp_v6_reqsk_send_ack(struct sk_buff *skb, struct
> request_sock *req) +static void tcp_v6_reqsk_send_ack(struct sk_buff
> *skb, struct request_sock *req, int reply_flags) {
>  	tcp_v6_send_ack(NULL, skb, tcp_rsk(req)->snt_isn + 1,
> tcp_rsk(req)->rcv_isn + 1, req->rcv_wnd, req->ts_recent); }
> -
> To unsubscribe from this list: send the line "unsubscribe
> netfilter-devel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

This is already _in_ the patch I've sent.

-- 
 KOVACS Krisztian
