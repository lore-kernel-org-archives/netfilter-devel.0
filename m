From: Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf] netfilter: ebtables: put module reference when an
 incorrect extension is found
Date: Tue, 23 Aug 2016 11:10:09 +0200
Message-ID: <20160823091009.GF8820@orbyte.nwl.cc>
References: <9117dc544fa8d93e00e1d6aeb2db97ffea89155f.1471939966.git.sd@queasysnail.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Sabrina Dubroca <sd@queasysnail.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:54984 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752780AbcHWJKL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Aug 2016 05:10:11 -0400
Content-Disposition: inline
In-Reply-To: <9117dc544fa8d93e00e1d6aeb2db97ffea89155f.1471939966.git.sd@queasysnail.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 23, 2016 at 10:20:31AM +0200, Sabrina Dubroca wrote:
> commit bcf493428840 ("netfilter: ebtables: Fix extension lookup with
> identical name") added a second lookup in case the extension that was
> found during the first lookup matched another extension with the same
> name, but didn't release the reference on the incorrect module.
> 
> Fixes: bcf493428840 ("netfilter: ebtables: Fix extension lookup with identical name")
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>

Acked-by: Phil Sutter <phil@nwl.cc>
