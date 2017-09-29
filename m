From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2 4/5] rule: Refactor chain_print_declaration()
Date: Fri, 29 Sep 2017 12:26:57 +0200
Message-ID: <20170929102657.GD2720@salvia>
References: <20170928151745.28426-1-phil@nwl.cc>
 <20170928151745.28426-5-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>,
        Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [213.95.27.120] ([213.95.27.120]:59029 "EHLO
        ganesha.gnumonks.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750936AbdI2K2J (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2017 06:28:09 -0400
Content-Disposition: inline
In-Reply-To: <20170928151745.28426-5-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 28, 2017 at 05:17:44PM +0200, Phil Sutter wrote:
> Instead of having two nearly identical printf() calls for netdev and
> other chains, print the common parts separately and include the device
> bit only for netdev chains.

Applied, thanks.
