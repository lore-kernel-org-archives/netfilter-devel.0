From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/6] netfilter: ipset: Remove unnecessary OOM logging
 messages
Date: Wed, 07 Sep 2011 16:42:59 +0200
Message-ID: <4E6782F3.7040501@trash.net>
References: <1315339147-9617-1-git-send-email-kadlec@blackhole.kfki.hu> <1315339147-9617-4-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Joe Perches <joe@perches.com>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61988 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab1IGQ0X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:26:23 -0400
In-Reply-To: <1315339147-9617-4-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06.09.2011 21:59, Jozsef Kadlecsik wrote:
> From: Joe Perches <joe@perches.com>
> 
> Removing unnecessary messages saves code and text.
> 
> Site specific OOM messages are duplications of a generic MM
> out of memory message and aren't really useful, so just
> delete them.

This one is already in my tree.
