From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] Fix debug_proto_ctx()
Date: Thu, 24 Aug 2017 18:11:58 +0200
Message-ID: <20170824161158.GA8617@salvia>
References: <20170824160418.19507-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:58669 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753288AbdHXQMX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 12:12:23 -0400
Content-Disposition: inline
In-Reply-To: <20170824160418.19507-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 24, 2017 at 06:04:18PM +0200, Phil Sutter wrote:
> Debug mask check was done against wrong flag, causing protocol context
> debug output being printed when only --debug=netlink was given.

Applied.
