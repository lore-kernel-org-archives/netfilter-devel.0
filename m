From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] tests: Fix a memory leak
Date: Mon, 14 Apr 2014 10:49:24 +0200
Message-ID: <20140414084924.GB6200@localhost>
References: <3a6157fa2be7124bafa2b681acb65eea9be432d2.1397411873.git.anarey@gmail.com>
 <77e2db7e796774f9155dcc91531dc8a13bea1a94.1397411811.git.anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47230 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbaDNIta (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:49:30 -0400
Content-Disposition: inline
In-Reply-To: <77e2db7e796774f9155dcc91531dc8a13bea1a94.1397411811.git.anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Apr 13, 2014 at 08:08:34PM +0200, Ana Rey wrote:
> Free nft_parse_err struct when there is an error in execute_test function.
> 
> It solves the following memory leak shown by valgrind.
> 
> ==7845== 24 bytes in 1 blocks are still reachable in loss record 1 of 2
> ==7845==    at 0x4C29590: calloc (vg_replace_malloc.c:618)
> ==7845==    by 0x401740: execute_test_file (nft-parsing-test.c:249)
> ==7845==    by 0x400EBB: main (nft-parsing-test.c:330)

Applied, thanks.
