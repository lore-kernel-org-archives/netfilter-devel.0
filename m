From: Patrick McHardy <kaber@trash.net>
Subject: Re: [0/3] conntrack event kernel issues
Date: Fri, 23 May 2008 12:03:36 +0200
Message-ID: <48369678.7000905@trash.net>
References: <1211447573.6878.36.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62704 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbYEWKDl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 May 2008 06:03:41 -0400
In-Reply-To: <1211447573.6878.36.camel@pumper.lan.luxnet.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Hugelshofer wrote:
> Hi,
> 
> I plan to use netfilter conntrack events to count the number of
> connections which timed out without having received a reply. To make
> this as efficient as possible I only want to monitor destroy events. I
> have noticed three issues with that and wrote patches to solve them.
> They follow in separate mails.
> 
> Please let me know what you think about them and if they could be useful
> for other people as well.
> 
> patch1: export ct->status on all conntrack events
> patch2: set SEEN_REPLY before destroying a conntrack on TCP RST
> patch3: new status flag SEEN_RELATED

I can't imagine other uses for this than the one you described,
especially for 2 and 3. Patch 3 also adds code in a hot path,
so unless someone can present good arguments in favour of these
patches, I don't really want to apply them.
