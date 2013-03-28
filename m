From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nf_tables: Transaction API proposal
Date: Thu, 28 Mar 2013 11:04:15 +0100
Message-ID: <20130328100415.GA7848@localhost>
References: <1362092898-23306-1-git-send-email-pablo@netfilter.org>
 <1364293144-4147-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1364293144-4147-2-git-send-email-tomasz.bursztyka@linux.intel.com>
 <20130327163550.GA5136@localhost>
 <5153F8E6.5080900@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51870 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab3C1KEV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Mar 2013 06:04:21 -0400
Content-Disposition: inline
In-Reply-To: <5153F8E6.5080900@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Tomasz,

On Thu, Mar 28, 2013 at 10:01:42AM +0200, Tomasz Bursztyka wrote:
> Hi Pablo,
> 
> >>--- a/include/uapi/linux/netfilter/nf_tables.h
> >>+++ b/include/uapi/linux/netfilter/nf_tables.h
> >>@@ -37,8 +37,9 @@ enum nf_tables_msg_types {
> >>  	NFT_MSG_NEWSETELEM,
> >>  	NFT_MSG_GETSETELEM,
> >>  	NFT_MSG_DELSETELEM,
> >>-	NFT_MSG_COMMIT,
> >>-	NFT_MSG_ABORT,
> >>+	NFT_MSG_START_TRANSACTION,
> >>+	NFT_MSG_COMMIT_TRANSACTION,
> >>+	NFT_MSG_ABORT_TRANSACTION,
> >No need to rename this and use long names, I would leave them as:
> >
> >NFT_MSG_BEGIN
> >NFT_MSG_COMMIT
> >NFT_MSG_ABORT
> 
> I did that change to get a fully explicit message name, as all the
> other ones are actually.
> Why not shortening to NFT_MSG_BEGIN_TRANS then? or something like that.

I was just trying to reduce the length of the patch, we can save a
couple of renames, but I leave it up to you.

> >>  	NFT_MSG_MAX,
> >>  };
> >>@@ -88,18 +89,12 @@ enum nft_chain_attributes {
> >>  };
> >>  #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
> >>-enum {
> >>-	NFT_RULE_F_COMMIT	= (1 << 0),
> >>-	NFT_RULE_F_MASK		= NFT_RULE_F_COMMIT,
> >>-};
> >I like the idea of removing the COMMIT flag by the explicit
> >NFT_MSG_BEGIN.
> >
> >>-static int nf_tables_dirty_add(struct nft_rule *rule, const struct nft_ctx *ctx)
> >>+static int nf_tables_transaction_add(const struct nft_ctx *ctx,
> >>+				     struct nft_transaction *transaction,
> >>+				     struct nft_rule *rule)
> >>  {
> >>  	struct nft_rule_update *rupd;
> >>-	/* Another socket owns the dirty list? */
> >>-	if (!ctx->net->nft.pid_owner)
> >>-		ctx->net->nft.pid_owner = ctx->nlh->nlmsg_pid;
> >>-	else if (ctx->net->nft.pid_owner != ctx->nlh->nlmsg_pid)
> >>-		return -EBUSY;
> >We still need that there is a single owner at time. Otherwise two
> >ongoing transactions may overlap.
> 
> One of the point of this RFC is to propose a way to enable
> transaction per-client.

I cannot come up with a way to resolve the case in which several
commit overlaps, as they may leave the rule-set in inconsistent state
temporarily. Using iptables as reference, it returns an error if you
try to commit while another commit is happening.

> It's actually not nice to enable only one transaction at a time,
> what do we do if the owner never commits?

Currently, the transaction is aborted if the process dies or it
finishes without committing. If you don't commit, I think the
behaviour is similar to databases, the client blocks others. We can
document this behaviour.

Alternatively, we also have batch helpers in libmnl:

http://git.netfilter.org/libmnl/tree/src/nlmsg.c#n387

We can batch several rule updates into one single netlink datagram
that is sent to the kernel. The batch needs to be started BEGIN and
finished by COMMIT. We may also decide to restrict the BEGIN and
COMMIT to batches.

Regards.
