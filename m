From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft,next-4.2] src: add netdev family support
Date: Tue, 16 Jun 2015 18:01:26 +0200
Message-ID: <20150616160126.GB7067@salvia>
References: <1434468714-5009-1-git-send-email-pablo@netfilter.org>
 <20150616154235.GK20951@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57897 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbbFPP4O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 11:56:14 -0400
Content-Disposition: inline
In-Reply-To: <20150616154235.GK20951@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 16, 2015 at 05:42:35PM +0200, Patrick McHardy wrote:
> On 16.06, Pablo Neira Ayuso wrote:
> > This patch adds support for the new 'netdev' table. So far, this table allows
> > you to create filter chains from ingress.
> > 
> > The following example shows a very simple base configuration with one table that
> > contains a basechain that is attached to the 'eth0':
> > 
> >  # nft list table netdev filter
> >  table netdev filter {
> >         chain eth0-ingress {
> >                 type filter hook ingress priority 0; device eth0; policy accept;
> 
> Just a minor thing, but my idea was rather
> 
> 		type filter hook ingress device eth0 priority 0;
> 
> IOW really have the device be part of the hook specification, not just a
> chain property, since it really is just that.

OK, will send another version of this patch.
