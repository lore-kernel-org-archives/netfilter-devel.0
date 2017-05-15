From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH 1/2] conntrackd: consolidate more code to
 use resync_send()
Date: Mon, 15 May 2017 18:21:51 +0200
Message-ID: <20170515162151.GA371@salvia>
References: <149431567027.23472.7461747418695885217.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:54309 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751314AbdEOQWA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 May 2017 12:22:00 -0400
Content-Disposition: inline
In-Reply-To: <149431567027.23472.7461747418695885217.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 09, 2017 at 09:41:10AM +0200, Arturo Borrero Gonzalez wrote:
> These digest_msg() functions can use resync_send() as well.
> 
> While at it, bring back a call to kernel_resync() in notrack_local() which was
> lost in a previous commit.

Applied, thanks.
