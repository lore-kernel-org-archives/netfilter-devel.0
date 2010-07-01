From: Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [PATCH] extensions: libxt_quota.c: Support option negation
Date: Thu, 01 Jul 2010 14:10:22 +0300
Message-ID: <1277982622.20531.3.camel@chilepepper>
References: <20100701093506.GA3309@sortiz-mobl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: ext Samuel Ortiz <sameo@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:65400 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab0GALK6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Jul 2010 07:10:58 -0400
In-Reply-To: <20100701093506.GA3309@sortiz-mobl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2010-07-01 at 11:35 +0200, ext Samuel Ortiz wrote:
> The xt_quota_info flags should be set properly for the --quota option negation
> support.
> 
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> ---

Nice catch! I was trying this yesterday after our discussion and
couldn't get it to work.  Didn't have the time to investigate the
problem, good that you did :)

Tested-by: Luciano Coelho <luciano.coelho@nokia.com>


-- 
Cheers,
Luca.

