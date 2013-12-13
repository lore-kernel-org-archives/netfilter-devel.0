From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [libnftables PATCH 1/2] include: Update API documentation in
 sync with kernel's one
Date: Fri, 13 Dec 2013 09:42:11 +0200
Message-ID: <52AABA53.4090606@linux.intel.com>
References: <1386853244-16783-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1386853244-16783-3-git-send-email-tomasz.bursztyka@linux.intel.com> <20131212180104.GA4137@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56480 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab3LMHmO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Dec 2013 02:42:14 -0500
In-Reply-To: <20131212180104.GA4137@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

>> Adding or modifying API's documentation on nf_tables.h.
> I have mangled the description to clarify that we are just getting the
> cached copy in sync with Linux 3.13-rc.

Ok thanks.

That reminds me we should do the same for iptables-nftables which has an 
even more outdated header.
I'll send a patch for it.

Tomasz

