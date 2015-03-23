From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH libnftnl] src: restore static array with expression
 operations
Date: Mon, 23 Mar 2015 13:33:06 +0000
Message-ID: <20150323133306.GW603@acer.localdomain>
References: <1427111052-5510-1-git-send-email-pablo@netfilter.org>
 <20150323114411.GH603@acer.localdomain>
 <20150323123400.GA6511@salvia>
 <20150323130805.GN603@acer.localdomain>
 <5510135A.9020809@skarnet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Laurent Bercot <ska-devel@skarnet.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61835 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbbCWNdL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2015 09:33:11 -0400
Content-Disposition: inline
In-Reply-To: <5510135A.9020809@skarnet.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 23.03, Laurent Bercot wrote:
> On 23/03/2015 14:08, Patrick McHardy wrote:
> >Yeah, me too. Do you have a pointer to the bug report? I'm surprised
> >that they are not invoked, from what I can tell that should happen in
> >any case.
> 
>  Hi Patrick,
>  I reported the bug on the netfilter@vger.kernel.org mailing-list
> (not the -devel one.)
> 
>  I just tested Pablo's proposed patch. It's working perfectly.

I don't doubt that :) The question is why its not working with
constructors.

Could you please forward your bug report? I'm not subscribed to
netfilter@. Thanks!
