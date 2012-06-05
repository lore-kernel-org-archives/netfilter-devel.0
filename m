From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [v5 PATCH 1/1] netfilter: Add fail-open support
Date: Wed, 6 Jun 2012 01:46:12 +0200
Message-ID: <20120605234612.GA27222@1984>
References: <20120524135631.24345.60254.sendpatchset@localhost.localdomain>
 <20120524135644.24345.694.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, vivk@us.ibm.com, svajipay@in.ibm.com,
	fw@strlen.de, netfilter-devel@vger.kernel.org, sri@us.ibm.com
To: Krishna Kumar <krkumar2@in.ibm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49810 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab2FEXqO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jun 2012 19:46:14 -0400
Content-Disposition: inline
In-Reply-To: <20120524135644.24345.694.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 24, 2012 at 07:26:44PM +0530, Krishna Kumar wrote:
> Implement a new "fail-open" mode where packets are not dropped
> upon queue-full condition. This mode can be enabled/disabled per
> queue using netlink NFQA_CFG_FLAGS & NFQA_CFG_MASK attributes.

Applied, thanks Florian and Krishna.
