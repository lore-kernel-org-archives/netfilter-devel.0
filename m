From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] main: Fix for return of uninitialized variable in
 nft_run_cmd_from_filename()
Date: Wed, 27 Sep 2017 14:11:34 +0200
Message-ID: <20170927121134.GB21470@salvia>
References: <20170921131039.2927-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:35571 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751287AbdI0MLm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2017 08:11:42 -0400
Content-Disposition: inline
In-Reply-To: <20170921131039.2927-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 21, 2017 at 03:10:39PM +0200, Phil Sutter wrote:
> If scanner_read_file() failed, the function would return an
> uninitialized value.

Also applied, thanks.
