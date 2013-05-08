From: Dmitry Popov <dp@highloadlab.com>
Subject: Re: [PATCH] xtables-addons: xt_RAWNAT: skb writable part might not
 include whole l4 header (ipv4 case).
Date: Wed, 8 May 2013 19:12:02 +0400
Message-ID: <20130508191202.4cb5233820bbb96a1e611329@highloadlab.com>
References: <20130505220504.1a3f2380a1e798b37e628dd1@highloadlab.com>
	<20130505222433.5c27056103b98340bba773df@highloadlab.com>
	<alpine.LNX.2.01.1305081322250.29391@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:47064 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab3EHPMP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 May 2013 11:12:15 -0400
Received: by mail-la0-f52.google.com with SMTP id fm20so1893148lab.11
        for <netfilter-devel@vger.kernel.org>; Wed, 08 May 2013 08:12:14 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1305081322250.29391@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 8 May 2013 13:32:57 +0200 (CEST)
Jan Engelhardt <jengelh@inai.de> wrote:

> >Also, shouldn't xt_RAWNAT depend on nf_defrag_ipv4 module? 
> 
> Dunno. Being a module for really "raw" nf_conntrack-less static NAT, I 
> feel no reason to make it hard-depend on nf_defrag, and instead leave it 
> up to the user whether or not to load nf_defrag.
> 
> I would tend to just ignore the fragment case for now, like many other 
> modules. Comments against?
> 

Yes, I think it's a better idea. The only argument against may be a
security hole if someone relies on xt_RAWNAT and doesn't use nf_defrag.
Though it's a poor argument imho.

> With nf_nat having gained IPv6 support, I also feel less inclined to 
> keep xt_RAWNAT around.
> 

nf_nat depends on conntrack and conntrack brings a huge overhead to 
such a simple task like NAT. xt_RAWNAT simply solves NAT problem, it
definitely has to stay.
