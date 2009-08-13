From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft] numeric ip protocol values and omitting filter tablename
Date: Thu, 13 Aug 2009 15:49:23 +0200
Message-ID: <4A8419E3.7070409@trash.net>
References: <4A81E801.606@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: "Christoph A." <casmls@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63358 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbZHMNt2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Aug 2009 09:49:28 -0400
In-Reply-To: <4A81E801.606@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Christoph A. wrote:
> Hi,
> 
> Is the default table (filter) also mandatory?
> 
> # nft add rule filter input meta iifname eth0 accept  (works)
> # nft add rule input meta iifname eth0 accept
> <cmdline>:1:16-19: Error: syntax error, unexpected meta, expecting string
> add rule input meta iifname eth0 accept
>                ^^^^

The table is mandatory, the "add" and "rule" parts are not.
So you can do:

nft filter input meta iifname eth0 accept

> just in case this is not expected:
> 
> # nft add rule filter input ip protocol 6 accept
> <cmdline>:1:35-35: Error: Could not resolve protocol name
> add rule filter input ip protocol 6 accept
> 
> ip protocol TCP accept (works)

Yes, this is currently a known bug, types do not parse in their
basetypes. I'll fix that before the next release, which is
happening in a few weeks.
