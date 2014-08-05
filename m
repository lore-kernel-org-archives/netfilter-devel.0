From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables null pointer
Date: Tue, 5 Aug 2014 15:39:07 +0200
Message-ID: <20140805133907.GA3782@salvia>
References: <CAFnufp1157iUqOpax6Po-PZivC_7TQSeQqtmJnnpNLVm3hzH9w@mail.gmail.com>
 <20140805100141.GA3480@salvia>
 <CAFnufp3mVBFVfLOmb3QofpPDubCYgzmOUc4u4vGM6gXv+6Rezg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="cNdxnHkX5QqsyA0e"
Cc: netfilter-devel@vger.kernel.org
To: Matteo Croce <technoboy85@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45307 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbaHENiv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Aug 2014 09:38:51 -0400
Content-Disposition: inline
In-Reply-To: <CAFnufp3mVBFVfLOmb3QofpPDubCYgzmOUc4u4vGM6gXv+6Rezg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 05, 2014 at 12:21:30PM +0200, Matteo Croce wrote:
> Yes it's reproducible with two config and two list:
> 
> # nft -f /dev/stdin <<EOF
> table ip nat {
>         chain post {
>                 type nat hook postrouting priority 0;
>                 ip saddr 192.168.0.0/24 oif eth0 snat 192.168.1.2
>         }
> }
> EOF
> 
> # nft -n list table nat
> 
> # nft -f /dev/stdin <<EOF
> table ip nat {
>         chain post {
>                 type nat hook postrouting priority 0;
>                 ip saddr 192.168.0.0/24 oif eth0 snat 192.168.1.2
>         }
> }
> EOF
> 
> # nft -n list table nat

Could you give a try to the following patch? Thanks.


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=x

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f95dc95..f7dce2b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -899,6 +899,9 @@ static struct nft_stats __percpu *nft_stats_alloc(const struct nlattr *attr)
 static void nft_chain_stats_replace(struct nft_base_chain *chain,
 				    struct nft_stats __percpu *newstats)
 {
+	if (newstats == NULL)
+		return;
+
 	if (chain->stats) {
 		struct nft_stats __percpu *oldstats =
 				nft_dereference(chain->stats);

--cNdxnHkX5QqsyA0e--
