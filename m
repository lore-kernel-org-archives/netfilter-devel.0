From: Philip Craig <philipc@snapgear.com>
Subject: Re: [LIBNL 08/09]: Support conntrack add/delete/query requests
Date: Mon, 21 Jan 2008 20:53:11 +1000
Message-ID: <47947997.7030301@snapgear.com>
References: <20080118165514.13385.44695.sendpatchset@localhost.localdomain> <20080118165525.13385.47304.sendpatchset@localhost.localdomain> <47945A5E.2070201@snapgear.com> <479469E5.3080205@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: tgraf@suug.ch, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.snapgear.com ([203.143.235.140]:35208 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753377AbYAUKvR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:51:17 -0500
In-Reply-To: <479469E5.3080205@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> nfnl_ct_query doesn't perform a full dump, so this still looks useful.

Will this do a full dump?
nfnl_ct_query(handle, nfnl_ct_alloc(), NLM_F_DUMP);

I'm okay with leaving it in there, I just didn't want to keep functions
that none of the other objects in libnl have if they aren't really needed.
