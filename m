From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack-tools] conntrackd: cthelper: ssdp: fix build
 with musl
Date: Thu, 24 Aug 2017 16:56:25 +0200
Message-ID: <20170824145625.GB18077@salvia>
References: <20170823072928.18380-1-stijn@linux-ipv6.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Stijn Tintel <stijn@linux-ipv6.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:58020 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753286AbdHXO4s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 10:56:48 -0400
Content-Disposition: inline
In-Reply-To: <20170823072928.18380-1-stijn@linux-ipv6.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 23, 2017 at 10:29:28AM +0300, Stijn Tintel wrote:
> For musl libc to expose the members of `struct tcphdr`, _GNU_SOURCE
> needs to be defined.
> 
> Fixes: b61c4543cbde ("conntrackd: cthelper: ssdp: Track UPnP eventing")
> Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>

Applied, thanks.
