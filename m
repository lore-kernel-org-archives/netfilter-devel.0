From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ip6tables: don't print out /128
Date: Mon, 8 Jul 2013 04:26:41 +0200
Message-ID: <20130708022641.GA14090@localhost>
References: <20130620201138.GA11634@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51876 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab3GHC1B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Jul 2013 22:27:01 -0400
Content-Disposition: inline
In-Reply-To: <20130620201138.GA11634@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

On Thu, Jun 20, 2013 at 04:11:38PM -0400, Phil Oester wrote:
> Similar to how iptables does not print /32 on IPv4 addresses, ip6tables
> should not print out /128 on IPv6 addresses.

I just look at the source of old iptables releases (1.4.11) and it
displays the /32 with iptables -L. I prefer if we restore that
behaviour, ie. we get it back to display /32, for historial reasons.
