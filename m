From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: Remove some backward-compat Kconfig symbols
Date: Sat, 4 Jan 2014 00:18:57 +0100
Message-ID: <20140103231857.GA16632@localhost>
References: <1388360631.2900.36.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39181 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbaACXTF convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jan 2014 18:19:05 -0500
Content-Disposition: inline
In-Reply-To: <1388360631.2900.36.camel@deadeye.wl.decadent.org.uk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 30, 2013 at 12:43:51AM +0100, Ben Hutchings wrote:
> Since Linux 3.4 or earlier, CONFIG_IP_NF_MATCH_ECN,
> CONFIG_IP_NF_MATCH_TTL, CONFIG_IP_NF_TARGET_TTL have just selected the
> xtables replacements for these symbols.  They should not be needed
> any more.

3.2-stable is already in place, I think those users can still benefit
from this compat stuff.
