From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] extensions: libxt_rateest: output all options in
 save hook
Date: Tue, 22 May 2012 20:41:17 +0200
Message-ID: <20120522184117.GB28870@1984>
References: <1337252589-1363-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47002 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905Ab2EVSlU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 May 2012 14:41:20 -0400
Content-Disposition: inline
In-Reply-To: <1337252589-1363-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 17, 2012 at 01:03:08PM +0200, Florian Westphal wrote:
> ipt-restore fails to parse the ipt-save output:
> zmatches -m rateest --rateest RE1 --rateest-pps --rateest-lt 5
> (should be "--rateest-pps 5 --rateest-lt").  Also, the "delta" option
> was never shown in -save output, but twice in some cases when using
> "iptables -L".
> 
> Also, the "b/pps1" option must be shown when "delta" option is used with
> relative mode.

Applied, thanks.

iptables release will follow-up soon, including this fix.
