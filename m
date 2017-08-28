From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] parser: Fix memleaks for STRING token (and derived
 ones)
Date: Mon, 28 Aug 2017 17:18:37 +0200
Message-ID: <20170828151837.GA4202@salvia>
References: <20170825111732.431-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:37529 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751241AbdH1PS7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2017 11:18:59 -0400
Content-Disposition: inline
In-Reply-To: <20170825111732.431-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 25, 2017 at 01:17:32PM +0200, Phil Sutter wrote:
> The common paradigm here is that all parser rules converting string
> tokens into symbols must free the string token if it's not used anymore.
> This is unrelated to the %destructor directive, since that will apply
> only if the parser discards the token, which is not the case then.
> 
> While being at it, simplify error handling in parser rule for listing
> conntrack helpers (error() won't return NULL) and drop the unused extra
> parameter passed to error() in level_type rule.

Applied, thanks Phil.
