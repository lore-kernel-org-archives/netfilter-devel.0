From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH 1/2] netfilter: nf_tables: partially rework commit and
 abort operation
Date: Mon, 04 Mar 2013 14:22:08 +0200
Message-ID: <513491F0.8030106@linux.intel.com>
References: <1362092898-23306-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2542 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497Ab3CDMWL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Mar 2013 07:22:11 -0500
In-Reply-To: <1362092898-23306-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

I would have some comments again, but mostly on the features it exposes.

I am not fully sure we want to dump non-active rules for instance.
And why limiting the transaction access to one netlink connection at a 
time? (though for commit operation it's fully relevant of course)

Things like that.
Could we see that in detail at the NFWS?

Tomasz


