From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] libxtables: fix getaddrinfo return value usage
Date: Wed, 11 Jun 2014 11:37:58 +0200
Message-ID: <20140611093758.GA5427@localhost>
References: <5397084D.8020703@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Domen Puncer <domen.puncer@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33343 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbaFKJiD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:38:03 -0400
Content-Disposition: inline
In-Reply-To: <5397084D.8020703@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 10, 2014 at 02:29:49PM +0100, Domen Puncer wrote:
> getaddrinfo return value on error can also be positive.

At quick glance, all EAI_* that I see are negative.

What problem are you experience? What case are you trying to catch?

Thanks.
