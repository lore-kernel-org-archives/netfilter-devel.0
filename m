From: Corey Hickey <bugfood-ml@fatooh.org>
Subject: Re: [PATCH 1/1] netfilter: Ignore bogus SACK option values in TCP
 conntrack
Date: Mon, 02 Sep 2013 13:39:09 -0700
Message-ID: <5224F76D.3010506@fatooh.org>
References: <1378148280-1153-1-git-send-email-kadlec@blackhole.kfki.hu> <1378148280-1153-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from juniper.fatooh.org ([173.255.221.30]:53491 "EHLO
	juniper.fatooh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758902Ab3IBUjK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Sep 2013 16:39:10 -0400
In-Reply-To: <1378148280-1153-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2013-09-02 11:58, Jozsef Kadlecsik wrote:
> The netfilter TCP conntrack used to mark packets with bogus SACK option
> values as INVALID. However, it seems broken SEQ anonymizers, which are
> responsible for such traffic, are not going to die out soon and conntrack
> effectively blocks traffic coming through such devices.
> 
> Better be liberal at conntrack level: when SACK is bogus, ignore it.
> 
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Reported-by: Corey Hickey <bugfood-ml@fatooh.org>
> Tested-by: Corey Hickey <bugfood-ml@fatooh.org>
> ---
>  net/netfilter/nf_conntrack_proto_tcp.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index 44d1ea3..cd67de8 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -640,6 +640,11 @@ static bool tcp_in_window(const struct nf_conn *ct,
>  	in_recv_win = !receiver->td_maxwin ||
>  		      after(end, sender->td_end - receiver->td_maxwin - 1);
>  
> +	/* Fall back to ACK when SACK is bogus */
> +	if (!(before(sack, receiver->td_end + 1) &&
> +	      after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1)))
> +		sack = ack;
> +
>  	pr_debug("tcp_in_window: I=%i II=%i III=%i IV=%i\n",
>  		 before(seq, sender->td_maxend + 1),
>  		 (in_recv_win ? 1 : 0),
> 


I've been running Jozsef's patch on linux-next compiled on 2013-08-19. I
can confirm that it fixes the problem I'm having with broken SEQ
randomization on FWSM, and I haven't seen any problems caused by it.

http://www.spinics.net/lists/netdev/msg246898.html

I'm still planning to work with my boss to disable SEQ randomization,
hopefully this week.

Thanks,
Corey
