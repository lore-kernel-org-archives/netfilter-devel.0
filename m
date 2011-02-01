From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] netfilter: arpt_mangle: fix return values of checkentry
Date: Tue, 01 Feb 2011 16:04:55 +0100
Message-ID: <4D482117.4090105@trash.net>
References: <20110201120116.3427.96097.stgit@decadence> <20110201120526.3427.83323.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43901 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab1BAPE6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 10:04:58 -0500
In-Reply-To: <20110201120526.3427.83323.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 01.02.2011 13:05, schrieb Pablo Neira Ayuso:
> In 135367b "netfilter: xtables: change xt_target.checkentry return type",
> the type returned by checkentry was changed from boolean to int, but the
> return values where not adjusted.
> 
> # arptables -I INPUT -i eth1 --h-length 6 --destination-mac 01:00:5e:00:01:01 -j mangle --mangle-mac-d 00:18:71:68:f2:34
> arptables: Input/output error
> 
> This broke arptables with the mangle target since it returns true
> under success, which is interpreted by xtables as >0, thus
> returning EIO.

Applied, thanks Pablo. I'll also push this to -stable once it hits
Linus' tree.
