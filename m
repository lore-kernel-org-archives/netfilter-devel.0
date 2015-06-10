From: Patrick McHardy <kaber@trash.net>
Subject: Re: nft rules processed in wrong network namespace
Date: Wed, 10 Jun 2015 17:28:55 +0200
Message-ID: <20150610152855.GA3406@acer.localdomain>
References: <CAASN2uOcjOKkXamC=FkYJKCJDTcA9nQUa5=OSn6YyUJ8SGvRfg@mail.gmail.com>
 <20150610140143.GA31977@salvia>
 <CAASN2uOP76OfF9QfaRFRMyuch2o5w02spf1=u+UkEoMs3znyHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Andreas Schultz <aschultz@warp10.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54918 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbbFJP27 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2015 11:28:59 -0400
Content-Disposition: inline
In-Reply-To: <CAASN2uOP76OfF9QfaRFRMyuch2o5w02spf1=u+UkEoMs3znyHw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10.06, Andreas Schultz wrote:
> On Wed, Jun 10, 2015 at 4:01 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Jun 10, 2015 at 12:07:27PM +0200, Andreas Schultz wrote:
> > [...]
> >> I think I have found the root cause why this happends.
> >>
> >> With iptables only the hooks defined by the ipt modules can ever exist and
> >> they do apply to all namespaces. Thus hooks are registered in the global list
> >> nf_hooks.
> >
> > I have an incomplete patchset here to introduce pernet hooks. Will
> > send this for review at some point.
> 
> Please, Could you share those patches? I have started on making nf_hooks
> into a pernet structure, but having something to start from would make this
> much simpler.
> 
> Also, in it's current form having netns and nftables support enabled at the
> same time can lead to some horribly broken (insecure) setups, e.g. I could
> intercept traffic for the host from within a docker container.
> 
> Shouldn't Kconfig be changed to prevent this?

If my understanding of the problem is correct, this (totally untested)
patch should prevent the problem until we have a proper fix.

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index f153b07..62e371a 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -124,6 +124,12 @@ nft_do_chain(struct nft_pktinfo *pkt, const struct nf_hook_ops *ops)
 	int rulenum;
 	unsigned int gencursor = nft_genmask_cur(net);
 
+	/* Workaround for processing in incorrect namespace until we have
+	 * per net hooks.
+	 */
+	if (read_pnet(&(pkt->in ? : pkt->out)->nd_net) != net)
+		return NF_ACCEPT;
+
 do_chain:
 	rulenum = 0;
 	rule = list_entry(&chain->rules, struct nft_rule, list);
