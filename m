From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/1] netfilter: ipset: Fix the order of listing of sets
Date: Tue, 19 Apr 2011 16:01:04 +0200
Message-ID: <4DAD95A0.1010200@trash.net>
References: <1303202370-12510-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39187 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab1DSOBK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:01:10 -0400
In-Reply-To: <1303202370-12510-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 19.04.2011 10:39, schrieb Jozsef Kadlecsik:
> A restoreable saving of sets requires that list:set type of sets
> come last and the code part which should have taken into account
> the ordering was broken. The patch fixes the listing order.

Applied, thanks Jozsef.
