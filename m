From: Patrick McHardy <kaber@trash.net>
Subject: Re: documentation bug: missing nat targets in man
Date: Tue, 9 Apr 2013 11:54:48 +0200
Message-ID: <20130409095448.GD26170@macbook.localnet>
References: <5163E3BE.3040609@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Mart Frauenlob <mart.frauenlob@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41122 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab3DIJyv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:54:51 -0400
Content-Disposition: inline
In-Reply-To: <5163E3BE.3040609@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 09, 2013 at 11:47:42AM +0200, Mart Frauenlob wrote:
> Hello,
> 
> I noticed there's quite new DNAT, SNAT, NETMAP support for
> ip6tables, but that information is missing in the man page.
> Anything else needed than just copying the according ipv4 *.man files?
> If so, want me do prepare a patch?

I guess you can rename the ipv4 specific man files to xt_... and
update them accordingly, the modules should behave similar to their
IPv4 counterparts.
