From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables (nft-compat) PATCH 8/8] nft: Initialize according to
 requested table, if any
Date: Tue, 11 Feb 2014 15:37:21 +0200
Message-ID: <52FA2791.3050009@linux.intel.com>
References: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1392115608-6733-9-git-send-email-tomasz.bursztyka@linux.intel.com> <20140211130701.GA24450@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:10524 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbaBKNhX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:37:23 -0500
In-Reply-To: <20140211130701.GA24450@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> Does it work the autochain load if you reload with rules in different
> tables? eg. filter and raw.

Indeed, no... While chasing a bug (patch 7 is the result) I forgot to do 
this simple test.

I could overload struct builtin_table {} for that.
But I just figured out another issue here, it will work if only we don't 
have /etc/xtables.conf file.

If you have such file, when xtables-restore will insert rules, it will 
always call nft_xtables_config_load() thus always trying to initialize 
tables that might be already there.

So there is a bigger fix here: I will add necessary stuff in handle to 
keep track of parsed file like tables and store which one has been 
initialized and not.

Will come back with a better patch then.

Tomasz
