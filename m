From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables/libnftnl release plan?
Date: Mon, 18 Sep 2017 18:24:53 +0200
Message-ID: <20170918162453.GA6000@salvia>
References: <20170918161835.GF30364@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:36340 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755990AbdIRQY5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2017 12:24:57 -0400
Content-Disposition: inline
In-Reply-To: <20170918161835.GF30364@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 18, 2017 at 06:18:35PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> What are your plans regarding release of libnftnl-1.0.8 and
> nftables-0.8?

As soon as I can integrate Florian's changes to support

        xyz set x,y

comma-separated values in with an assignment statement.
