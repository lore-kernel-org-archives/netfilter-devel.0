From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] netfilter: ipset: set match and SET target fixes
Date: Wed, 13 Apr 2011 13:47:15 +0200
Message-ID: <4DA58D43.5030504@trash.net>
References: <1302379382-32338-1-git-send-email-kadlec@blackhole.kfki.hu> <1302379382-32338-2-git-send-email-kadlec@blackhole.kfki.hu> <1302379382-32338-3-git-send-email-kadlec@blackhole.kfki.hu> <1302379382-32338-4-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Lennert Buytenhek <buytenh@wantstofly.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38840 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab1DMLrS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 07:47:18 -0400
In-Reply-To: <1302379382-32338-4-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 09.04.2011 22:03, schrieb Jozsef Kadlecsik:
> The SET target with --del-set did not work due to using wrongly
> the internal dimension of --add-set instead of --del-set.
> Also, the checkentries did not release the set references when
> returned an error. Bugs reported by Lennert Buytenhek.
> 

Applied, thanks Jozsef.
