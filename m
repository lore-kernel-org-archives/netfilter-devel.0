From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2 2/5] exthdr: Simplify tcp option printing a bit
Date: Fri, 29 Sep 2017 12:25:19 +0200
Message-ID: <20170929102519.GB2720@salvia>
References: <20170928151745.28426-1-phil@nwl.cc>
 <20170928151745.28426-3-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>,
        Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [213.95.27.120] ([213.95.27.120]:58982 "EHLO
        ganesha.gnumonks.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750936AbdI2K0c (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2017 06:26:32 -0400
Content-Disposition: inline
In-Reply-To: <20170928151745.28426-3-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 28, 2017 at 05:17:42PM +0200, Phil Sutter wrote:
> This eliminates the need for that temporary buffer.

Also applied, thanks.
