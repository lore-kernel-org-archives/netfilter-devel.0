From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: nf_ct_helper: don't discard helper if it
 is actually the same
Date: Tue, 12 Feb 2013 23:36:12 +0100
Message-ID: <20130212223612.GB7045@localhost>
References: <1360684793-32109-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:23986 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753539Ab3BLWgR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:36:17 -0500
Content-Disposition: inline
In-Reply-To: <1360684793-32109-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 12, 2013 at 04:59:53PM +0100, Florian Westphal wrote:
> commit 32f5376003920a8bc1bd97c6cddcf42df0b6a833
> (netfilter: nf_ct_helper: disable automatic helper re-assignment of different type)
> breaks transparent proxy scenarios.
> 
> For example, initial helper lookup might yield "ftp" (dport 21),
> while re-lookup after REDIRECT yields "ftp-2121".
> 
> This causes the autoassign code to toss the ftp helper, even
> though these are just different instances of the same.
> 
> Change the test to check for the helper function address instead
> of the helper address, as suggested by Pablo.

Also applied this one, thanks.
