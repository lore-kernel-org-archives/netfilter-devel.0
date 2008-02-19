From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/5] adds AF_BRIDGE support to PRINTPKT plugin
Date: Tue, 19 Feb 2008 11:54:30 +0100
Message-ID: <47BAB566.5090602@netfilter.org>
References: <20080211220753.796791654@endian.com> <20080211221056.540287033@endian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	ebtables-devel@lists.sourceforge.net
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46323 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756400AbYBSKyk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 05:54:40 -0500
In-Reply-To: <20080211221056.540287033@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Peter Warasin wrote:
> This patch adds support for AF_BRIDGE to
> the PRINTPKT plugin, which allows to form
> log lines for packets coming from ebtables.
> Currently it supports IPv4, IPv6 and ARP.

Applied. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
