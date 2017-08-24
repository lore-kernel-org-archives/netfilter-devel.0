From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 0/4] Memleak fixes and some minor cleanups
Date: Thu, 24 Aug 2017 19:19:03 +0200
Message-ID: <20170824171903.GA27332@salvia>
References: <20170824171413.31737-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:59357 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753202AbdHXRT1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 13:19:27 -0400
Content-Disposition: inline
In-Reply-To: <20170824171413.31737-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 24, 2017 at 07:14:09PM +0200, Phil Sutter wrote:
> The following series fixes two sources of memleaks as reported by
> valgrind (see patches 1 and 4). Patches 2 and 3 contain some minor
> cleanups I found while searching for the leaks.

Series applied, thanks.
