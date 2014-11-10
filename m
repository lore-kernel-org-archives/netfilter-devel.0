From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -nf] nft: masq: fix uninitialized range in
 nft_masq_{ipv4,ipv6}_eval
Date: Mon, 10 Nov 2014 20:20:24 +0100
Message-ID: <20141110192024.GA25464@salvia>
References: <1415370894-31528-1-git-send-email-dborkman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: arturo.borrero.glez@gmail.com, netfilter-devel@vger.kernel.org
To: Daniel Borkmann <dborkman@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37399 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbaKJTSh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:18:37 -0500
Content-Disposition: inline
In-Reply-To: <1415370894-31528-1-git-send-email-dborkman@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 07, 2014 at 03:34:54PM +0100, Daniel Borkmann wrote:
> When transferring from the original range in nf_nat_masquerade_{ipv4,ipv6}()
> we copy over values from stack in from min_proto/max_proto due to uninitialized
> range variable in both, nft_masq_{ipv4,ipv6}_eval. As we only initialize
> flags at this time from nft_masq struct, just zero out the rest.

Applied, thanks Daniel!
