From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables kernel - PATCH 1/2] netfilter: nf_tables: Update uapi
 nftables netlink header documentation
Date: Fri, 11 Oct 2013 10:43:07 +0200
Message-ID: <20131011084307.GA3956@localhost>
References: <1381139880-20311-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1381139880-20311-2-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45970 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047Ab3JKInM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:43:12 -0400
Content-Disposition: inline
In-Reply-To: <1381139880-20311-2-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 07, 2013 at 12:57:59PM +0300, Tomasz Bursztyka wrote:
> Thus all types, attributes, flags and so on get properly updated as the
> very first ones were.

Applying: netfilter: nf_tables: Update uapi nftables netlink header
documentation
/home/pablo/devel/scm/git-kernel/korg/nftables-backup/.git/rebase-apply/patch:76:
trailing whitespace.
 * @NFT_RULE_COMPAT_F_INV: invert the check result
/home/pablo/devel/scm/git-kernel/korg/nftables-backup/.git/rebase-apply/patch:87:
trailing whitespace.
 * @NFTA_RULE_COMPAT_FLAGS: bitmask of enum nft_rule_compat_flags
 * (NLA_U32)
/home/pablo/devel/scm/git-kernel/korg/nftables-backup/.git/rebase-apply/patch:114:
trailing whitespace.
 * @NFTA_BYTEORDER_SIZE: _TODO_ (NLA_U32)
warning: 3 lines add whitespace errors.

Please, mind with whitespace errors at the end of lines. I have fixed
them here.

Applied, thanks.
