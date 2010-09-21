From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/4] netfilter: ctnetlink: allow to specify the expectation
 flags
Date: Tue, 21 Sep 2010 17:18:44 +0200
Message-ID: <4C98CCD4.2050801@trash.net>
References: <20100921092843.3279.6914.stgit@decadence> <20100921093508.3279.65795.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39227 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab0IUP1a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Sep 2010 11:27:30 -0400
In-Reply-To: <20100921093508.3279.65795.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 21.09.2010 11:35, schrieb Pablo Neira Ayuso:
> With this patch, you can specify the expectation flags for user-space
> created expectations.

We don't seem to be dumping the flags to userspace. I think this
should be added for consistency.
