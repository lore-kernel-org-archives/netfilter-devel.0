From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: fix type in parsing in
 nf_tables_set_alloc_name
Date: Sat, 4 Jan 2014 00:02:47 +0100
Message-ID: <20140103230247.GA6283@localhost>
References: <1388490005-6771-1-git-send-email-dborkman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Daniel Borkmann <dborkman@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38289 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbaACXC4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jan 2014 18:02:56 -0500
Content-Disposition: inline
In-Reply-To: <1388490005-6771-1-git-send-email-dborkman@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 31, 2013 at 12:40:05PM +0100, Daniel Borkmann wrote:
> In nf_tables_set_alloc_name(), we are trying to find a new, unused
> name for our new set and interate through the list of present sets.
> As far as I can see, we're using format string %d to parse already
> present names in order to mark their presence in a bitmap, so that
> we can later on find the first 0 in that map to assign the new set
> name to. We should rather use a temporary variable of type int to
> store the result of sscanf() to, and for making sanity checks on.

Applied, thanks.
