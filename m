From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/7] Netfilter updates for nf-next tree (2.6.31)
Date: Tue, 02 Jun 2009 14:54:21 +0200
Message-ID: <4A2520FD.1080608@trash.net>
References: <20090602114933.7677.25219.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38850 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbZFBMyX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2009 08:54:23 -0400
In-Reply-To: <20090602114933.7677.25219.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Hi Patrick,
> 
> Here it follows the first bunch of updates for your nf-next tree.
> This patchset is mostly oriented to cleanups and the conntrack event
> subsystem.
> 
> Wait for your comments! Thanks!

I'll review them now. One question though - since you appear to
be using git, could you make your tree (well, the parts you want
to merge) accessible somewhere? Doing a git pull saves a lot of
time compared to applying each patch individually ...
