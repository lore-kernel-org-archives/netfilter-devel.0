From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft,next-4.2] src: add netdev family support
Date: Tue, 16 Jun 2015 17:42:35 +0200
Message-ID: <20150616154235.GK20951@acer.localdomain>
References: <1434468714-5009-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56360 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbbFPPmj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 11:42:39 -0400
Content-Disposition: inline
In-Reply-To: <1434468714-5009-1-git-send-email-pablo@netfilter.org>
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
>                 type filter hook ingress priority 0; device eth0; policy accept;

Just a minor thing, but my idea was rather

		type filter hook ingress device eth0 priority 0;

IOW really have the device be part of the hook specification, not just a
chain property, since it really is just that.
