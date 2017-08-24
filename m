From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack-tools] conntrack: Show multiple CPUs stats from
 proc
Date: Thu, 24 Aug 2017 16:56:13 +0200
Message-ID: <20170824145613.GA18077@salvia>
References: <1503326306-23437-1-git-send-email-chiehmin18@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Chieh-Min Wang <chiehmin18@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:58012 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751256AbdHXO4i (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 10:56:38 -0400
Content-Disposition: inline
In-Reply-To: <1503326306-23437-1-git-send-email-chiehmin18@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 21, 2017 at 10:38:26PM +0800, Chieh-Min Wang wrote:
> When read cpu conntrack stats from /proc/net/stat/nf_conntrack,
> it only shows stats from cpu0.
> 
> This patch list all cpus' conntrack stats like what `nfexp_stats_cb` did.

Applied, thanks.
