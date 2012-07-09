From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/2] netfilter: ipset: timeout fixing bug broke SET
 target special timeout value
Date: Mon, 09 Jul 2012 00:29:03 -0700 (PDT)
Message-ID: <20120709.002903.592402805831614695.davem@davemloft.net>
References: <1341574779-3373-1-git-send-email-pablo@netfilter.org>
	<1341574779-3373-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:53702 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2GIH3E (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Jul 2012 03:29:04 -0400
In-Reply-To: <1341574779-3373-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: pablo@netfilter.org
Date: Fri,  6 Jul 2012 13:39:38 +0200

> +	if (add_opt.timeout != IPSET_NO_TIMEOUT
> +	    && add_opt.timeout > UINT_MAX/MSEC_PER_SEC)

We do not write conditionals like this, with operators beginning
a continued line.  Instead, write this as:

	if (a &&
	    b)

Thanks.
