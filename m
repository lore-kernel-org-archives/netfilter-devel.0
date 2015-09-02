From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl 0/3] use nftnl_ prefix
Date: Wed, 2 Sep 2015 17:02:55 +0200
Message-ID: <20150902150255.GA10168@salvia>
References: <1441205064-9240-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33919 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311AbbIBO4a (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Sep 2015 10:56:30 -0400
Content-Disposition: inline
In-Reply-To: <1441205064-9240-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 02, 2015 at 04:44:23PM +0200, Pablo Neira Ayuso wrote:
> This patchset renames the existing functions and definitions to use the nftnl_
> prefix to prepare the introduction of the higher level library, which will use
> the nft_ prefix.
> 
> The patchset does not break backward compatibility: Neither compilation not
> existing binaries.
> 
> The patchset keeps the nft_ symbols around as aliases for the nftnl_ symbols.
> Moreover, the header files contain the old nft_ definitions so clients of this
> library don't break all of a sudden.
> 
> Please, let me know if you observe any problem with this. I would like that
> this changes are pushed to master before the next release.

Just pushed out this branch:

http://git.netfilter.org/libnftnl/log/?h=nftnl

Just in case the largest Patch 2/3 does not reach the list.
