From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft,next-4.2,v2] src: add netdev family support
Date: Wed, 17 Jun 2015 10:21:46 +0200
Message-ID: <20150617082146.GA13215@acer.localdomain>
References: <1434471906-8583-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64220 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbbFQIVt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Jun 2015 04:21:49 -0400
Content-Disposition: inline
In-Reply-To: <1434471906-8583-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16.06, Pablo Neira Ayuso wrote:
> This patch adds support for the new 'netdev' table. So far, this table allows
> you to create filter chains from ingress.
> 
> The following example shows a very simple base configuration with one table that
> contains a basechain that is attached to the 'eth0':
> 
>  # nft list table netdev filter
>  table netdev filter {
>         chain eth0-ingress {
>                 type filter hook ingress device eth0 priority 0; policy accept;
>         }
>  }
> 
> You can test that this works by adding a simple rule with counters:
> 
>  # nft add rule netdev filter eth0-ingress counter

Looks fine. I'm thinking we might be able to simplify to grammar, but I'll simply
try once your patch is in the tree.
