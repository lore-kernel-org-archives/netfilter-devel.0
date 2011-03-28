From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] netfilter:ipset: list:set timeout variant fixes
Date: Mon, 28 Mar 2011 14:25:50 +0200
Message-ID: <4D907E4E.3010202@trash.net>
References: <1301049733-32160-1-git-send-email-kadlec@blackhole.kfki.hu> <1301049733-32160-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41011 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab1C1M0I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Mar 2011 08:26:08 -0400
In-Reply-To: <1301049733-32160-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 25.03.2011 11:42, schrieb Jozsef Kadlecsik:
> - the timeout value was actually not set
> - the garbage collector was broken
> 
> The variant is fixed, the tests to the ipset testsuite are added.

Applied, thanks Jozsef.
