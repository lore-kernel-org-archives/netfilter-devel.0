From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter: nf_tables: don't update chain with unset
 counters
Date: Tue, 05 Aug 2014 18:07:11 +0200
Message-ID: <1407254831.3178.90.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1407252636-3459-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	technoboy85@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:36631 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaHEQHW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Aug 2014 12:07:22 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so1610766wiv.3
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Aug 2014 09:07:16 -0700 (PDT)
In-Reply-To: <1407252636-3459-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2014-08-05 at 17:30 +0200, Pablo Neira Ayuso wrote:
> Fix possible replacemen of the per-cpu chain counters by null
> pointer when updating an existing chain in the commit path.
> 
> Reported-by: Matteo Croce <technoboy85@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_tables_api.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index f95dc95..f7dce2b 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -899,6 +899,9 @@ static struct nft_stats __percpu *nft_stats_alloc(const struct nlattr *attr)
>  static void nft_chain_stats_replace(struct nft_base_chain *chain,
>  				    struct nft_stats __percpu *newstats)
>  {
> +	if (newstats == NULL)
> +		return;
> +
>  	if (chain->stats) {
>  		struct nft_stats __percpu *oldstats =
>  				nft_dereference(chain->stats);

This looks strange. Real bug is that nft_dump_stats() should not try to
fold percpu stats and output something if 'stats' is NULL ?

Otherwise, why nft_chain_stats_replace() checks if previous pointer is
NULL ?

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 93692d692ebc..9fbbb42dcffa 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -648,6 +648,9 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
 	u64 pkts, bytes;
 	int cpu;
 
+	if (!stats)
+		return 0;
+
 	memset(&total, 0, sizeof(total));
 	for_each_possible_cpu(cpu) {
 		cpu_stats = per_cpu_ptr(stats, cpu);


