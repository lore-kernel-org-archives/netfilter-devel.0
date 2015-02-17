From: Patrick McHardy <kaber@trash.net>
Subject: Re: [v4 nf 0/5] Named counter objects support in nft
Date: Tue, 17 Feb 2015 12:23:02 -0500
Message-ID: <20150217172301.GA7558@acer.localdomain>
References: <cover.1423075525.git.ana@soleta.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey Botello <ana@soleta.eu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47035 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbbBQRXH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2015 12:23:07 -0500
Content-Disposition: inline
In-Reply-To: <cover.1423075525.git.ana@soleta.eu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04.02, Ana Rey Botello wrote:
> Hi,
> 
> With this patchset, we add named counter objects support. It is similar
> to nfacct in iptables.

Thanks for doing this work. I have some patches coming up very soon
which have kind of an intersection with your work, so I'd ask for a
little bit of patience until we can integrate them.

Basically what my patches will do is to allow to statically or
dynamically "stateify" and expression type, including counters.
Your patches are one of the missing pieces in doing that, however
we most likely want to change them in a way that they not only
allow access to counter objects, but any kind of expression. Its
a rather minor change to your work, but requires some things I'm
still working on. Hope to have something ready by the end of next
week.

I'll keep you posted.

