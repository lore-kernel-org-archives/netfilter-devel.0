From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] build: fail in configure on missing dependency for
 optional component
Date: Fri, 26 Jul 2013 16:33:30 +0200
Message-ID: <20130726143330.GA26844@localhost>
References: <1374451358-13294-1-git-send-email-willemb@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Willem de Bruijn <willemb@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44641 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756848Ab3GZOdk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:33:40 -0400
Content-Disposition: inline
In-Reply-To: <1374451358-13294-1-git-send-email-willemb@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jul 21, 2013 at 08:02:38PM -0400, Willem de Bruijn wrote:
> The build of utils/nfbpf_compile depends on libpcap. If configure is
> run with --enable-bpf-compiler, the script succeeds, but make fails.
> 
> This small patch adds a test for the dependency (libpcap) in configure
> and fails hard if not found.
> 
> ---
> 
> This small patch addresses your comment when merging the original
> nfbpf_compiler commit 1ac30c97c339957b6e3c5cf571de7bc38c827730.
> Sorry that it took me so long. Maybe it is not relevant anymore.

Yes, I still want this in the tree. Applied, thanks Willem.
