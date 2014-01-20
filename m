From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [HEADS UP] libnftables renamed to libnftnl
Date: Mon, 20 Jan 2014 15:50:15 +0200
Message-ID: <52DD2997.4040506@linux.intel.com>
References: <20140120121935.GA2794@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:22636 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaATNuR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jan 2014 08:50:17 -0500
In-Reply-To: <20140120121935.GA2794@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Thus we have to adapt iptables to look for libnfnl headers instead of 
libnftables?
(and nftables too btw).

Tomasz
