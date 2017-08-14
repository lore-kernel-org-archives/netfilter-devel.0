From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH] conntrackd: remove warning for -S
Date: Mon, 14 Aug 2017 11:35:47 +0200
Message-ID: <20170814093547.GA11835@salvia>
References: <150228117223.32474.3290205091216581281.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:45527 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752560AbdHNJgL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Aug 2017 05:36:11 -0400
Content-Disposition: inline
In-Reply-To: <150228117223.32474.3290205091216581281.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 09, 2017 at 02:19:32PM +0200, Arturo Borrero Gonzalez wrote:
> Remove the warning message for the -S option which has been deprecated for
> years now.
> 
> Users calling conntrackd with this switch activated will now get an error.

Applied, thanks Arturo.
