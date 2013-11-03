From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] iptables: improve chain name validation
Date: Sun, 3 Nov 2013 14:33:42 -0800
Message-ID: <20131103223342.GA3239@home>
References: <20131005163315.GA16881@home>
 <20131103202323.GA31399@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:38930 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab3KCWdp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Nov 2013 17:33:45 -0500
Received: by mail-pb0-f48.google.com with SMTP id mc17so6336958pbc.7
        for <netfilter-devel@vger.kernel.org>; Sun, 03 Nov 2013 14:33:44 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131103202323.GA31399@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 03, 2013 at 09:23:23PM +0100, Pablo Neira Ayuso wrote:
> Applied, thanks Phil.
> 
> I have mangled this patch to include the ip6tables.c chunk, let me
> know if you find any problem with it.

Looks good.  Sorry I missed the -6 version.

Phil
