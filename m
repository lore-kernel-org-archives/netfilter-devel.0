From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] build: bump library versioning
Date: Wed, 16 Sep 2015 20:22:51 +0200
Message-ID: <20150916182251.GA3346@salvia>
References: <1442423567-12120-1-git-send-email-jengelh@inai.de>
 <20150916172836.GA29575@salvia>
 <20150916180048.GA4886@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46078 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbbIPSQK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Sep 2015 14:16:10 -0400
Content-Disposition: inline
In-Reply-To: <20150916180048.GA4886@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 16, 2015 at 08:00:48PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 16, 2015 at 07:28:36PM +0200, Pablo Neira Ayuso wrote:
[...]
> Sorry, what you propose is fine actually. But this should be
> LIBNFTNL_3 instead, I already bumped LIBVERSION from 2:0:2 to 3:0:3,
> see 9e1e8052025fde.
> 
> If no concerns, I'll mangle your patch to make use LIBNFTNL_3 instead.

I think your LIBNFTNL_4 is intentional, now we're at 3:0:3 after
1.0.4, so to escape the current situation upcoming libnftnl-1.0.5
should be 4:0:0, hence the LIBNFTNL_4 in the map file.
