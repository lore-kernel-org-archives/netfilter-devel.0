From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH 2/2] conntrackd: request resync at startup
Date: Mon, 15 May 2017 18:22:04 +0200
Message-ID: <20170515162204.GB371@salvia>
References: <149431567027.23472.7461747418695885217.stgit@nfdev2.cica.es>
 <149431567553.23472.560268360348133271.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:54317 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751314AbdEOQWO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 May 2017 12:22:14 -0400
Content-Disposition: inline
In-Reply-To: <149431567553.23472.560268360348133271.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 09, 2017 at 09:41:15AM +0200, Arturo Borrero Gonzalez wrote:
> If a node goes to live, ask the other for resync at startup.
> This has to be done usually by hand, but I guess is an operation common
> enough to add some bits to ease people life here.

Also applied, thanks.
