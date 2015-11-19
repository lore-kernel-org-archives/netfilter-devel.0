From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 2/2] tests: regression: allow to run tests from
 anywhere
Date: Thu, 19 Nov 2015 23:00:50 +0100
Message-ID: <20151119220050.GB25336@breakpoint.cc>
References: <1447959109-17295-1-git-send-email-pablombg@gmail.com>
 <1447959109-17295-2-git-send-email-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50034 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758006AbbKSWAw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Nov 2015 17:00:52 -0500
Content-Disposition: inline
In-Reply-To: <1447959109-17295-2-git-send-email-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo M. Bermudo Garay <pablombg@gmail.com> wrote:
> Since 357d8cf "tests: use the src/nft binary instead of $PATH one", the
> tests script needs to be executed from nftables repository root. Now
> the script can be run from any location and also checks the binary
> existence.
> 
> To run a single test file, the path must be relative from the directory
> where you launch the script.

Looks good, I pushed both patches to nft master.

Thanks!
