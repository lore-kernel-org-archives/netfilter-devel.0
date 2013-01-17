From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: add include file to nf_conntrack_snmp.c
Date: Fri, 18 Jan 2013 00:36:37 +0100
Message-ID: <20130117233637.GA15922@1984>
References: <20121228201708.77f1c376@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35435 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab3AQXgk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jan 2013 18:36:40 -0500
Content-Disposition: inline
In-Reply-To: <20121228201708.77f1c376@nehalam.linuxnetplumber.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 28, 2012 at 08:17:08PM -0800, Stephen Hemminger wrote:
> Prototype for nf_nat_snmp_hook is in nf_conntrack_snmp.h therefore
> it should be included to get type checking. Found by sparse.

Applied, thanks Stephen.
