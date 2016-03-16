From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 1/3] netfilter: nftables: add connlabel set
 support
Date: Wed, 16 Mar 2016 10:39:33 +0100
Message-ID: <20160316093933.GA16938@breakpoint.cc>
References: <1458058211-11147-1-git-send-email-fw@strlen.de>
 <1458058211-11147-2-git-send-email-fw@strlen.de>
 <20160315170813.GA25284@salvia>
 <20160315230921.GD8185@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56922 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753912AbcCPJjf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Mar 2016 05:39:35 -0400
Content-Disposition: inline
In-Reply-To: <20160315230921.GD8185@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > @@ -777,6 +778,7 @@ enum nft_ct_attributes {
> > >  	NFTA_CT_KEY,
> > >  	NFTA_CT_DIRECTION,
> > >  	NFTA_CT_SREG,
> > > +	NFTA_CT_LABEL,
> > 
> > We can probably add:
> > 
> >         NFTA_CT_IMM
> 
> Right, we can derive the exact type based on the key.
> 
> > This would be a nested attribute, then inside there we can define the:
> > 
> >         NFTA_CT_LABEL
> 
> Hmm, why a nested attribute?
> What do we gain from that?
> 
> Do you want the nested attr so that we can define policies
> for the "immediate subtypes"...?
> 
> If its the latter, then ok.
> 
> I'd then suggest adding a new enum, for instance:
> 
> NFTA_CT_IMM_LABEL
> 
> That appear as nested attrs inside the NFTA_CT_IMM one.

i.e., this:

  * @NFTA_CT_SREG: source register (NLA_U32)
+ * @NFTA_CT_IMM: immediate value (NLA_NESTED)
  */
 enum nft_ct_attributes {
        NFTA_CT_UNSPEC,
@@ -783,6 +783,17 @@ enum nft_ct_attributes {
 };
 #define NFTA_CT_MAX            (__NFTA_CT_MAX - 1)
 
+/*
+ * enum nft_ct_imm_attributes - nf_tables ct expression immediate attributes
+ *
+ * @NFTA_CT_IMM_LABEL: label bit (NLA_U32)
+ */
+enum nft_ct_imm_attributes {
+       NFT_CT_IMM_LABEL,
+       __NFT_IMM_MAX
+};
+#define NFT_CT_IMM_MAX (__NFT_IMM_MAX - 1)

I still don't see the advantage of using a nested attribute for
this since we cannot have mutliple IMM keys at once.

Or was that something that you were interested in?

In that case we'd have to ignore NFTA_CT_KEY and just
rely on the presence of IMM values to tell us what we should do.
