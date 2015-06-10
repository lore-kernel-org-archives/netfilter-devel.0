From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nft netdev family bindings
Date: Wed, 10 Jun 2015 16:02:33 +0200
Message-ID: <20150610140233.GB31977@salvia>
References: <20150605133533.GA4024@acer.localdomain>
 <20150605155827.GA3505@salvia>
 <20150605155922.GC4024@acer.localdomain>
 <20150605164742.GA15198@acer.localdomain>
 <20150608114058.GA4165@salvia>
 <20150609092318.GA25651@acer.localdomain>
 <20150609105245.GA2811@salvia>
 <20150609105712.GA29356@acer.localdomain>
 <20150609114630.GA2995@salvia>
 <20150609121325.GA8111@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40833 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932820AbbFJN5Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2015 09:57:24 -0400
Content-Disposition: inline
In-Reply-To: <20150609121325.GA8111@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 09, 2015 at 02:13:25PM +0200, Patrick McHardy wrote:
[...]
> The question is if its the correct abstraction, and I don't think so.

Your call Patrick, I'll send a patch to move this attribute to the
base chain.
