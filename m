From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: iptables-xml segfault if missing -A
Date: Wed, 29 Jan 2014 20:23:44 +0100
Message-ID: <20140129192344.GA15750@localhost>
References: <20140124060658.GA25711@home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44765 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbaA2TXt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Jan 2014 14:23:49 -0500
Content-Disposition: inline
In-Reply-To: <20140124060658.GA25711@home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 23, 2014 at 10:06:58PM -0800, Phil Oester wrote:
> As pointed out by Bernhard Reutner-Fischer, a malformed line fed to
> iptables-xml such as the below with a missing space after the -A:
> 
> 	-APOSTROUTING -d 1.1.1.1/32 -p tcp -j MASQUERADE
> 
> causes a segfault.  Patch attached.
> 
> This closes netfilter bugzilla #886.

Applied, thanks.
