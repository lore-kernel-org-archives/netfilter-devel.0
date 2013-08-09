From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables RFC v3 PATCH 16/16] xtables: Support -Z
 options for a given rule number
Date: Sat, 10 Aug 2013 00:02:10 +0200
Message-ID: <20130809220210.GE7102@localhost>
References: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1376055090-26551-17-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49132 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031243Ab3HIWCW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 18:02:22 -0400
Content-Disposition: inline
In-Reply-To: <1376055090-26551-17-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 09, 2013 at 04:31:30PM +0300, Tomasz Bursztyka wrote:
> Support for such command:
> xtbles-multi xtables -Z foo 4

If you add an interface, you also have to add the first client of that
new interface.

This should be collapsed with patch 15/16.
