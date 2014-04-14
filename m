From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH 3/5] netfilter: nf_tables: Add meta expression key for
 bridge interface name
Date: Mon, 14 Apr 2014 14:48:43 +0300
Message-ID: <534BCB1B.8040907@linux.intel.com>
References: <1396956324-17803-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1396956324-17803-4-git-send-email-tomasz.bursztyka@linux.intel.com> <20140414113657.GA21331@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37061 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbaDNLsq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:48:46 -0400
In-Reply-To: <20140414113657.GA21331@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> I think you can remove the trailing _bridge, it's obvious that we're
> already in the bridge directory.

All family-tight nftables modules seem to follow this rule, reason why I 
did so.
(cf. reject, chain nat, etc...)

Anyway, will resend a new version applying your Kconfig comment.

Tomasz
