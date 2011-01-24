From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Incorrect xt_iprange boundary check for IPv6
Date: Mon, 24 Jan 2011 21:38:51 +0100
Message-ID: <4D3DE35B.6000108@trash.net>
References: <1295871227-2545-1-git-send-email-jacob@internet24.de> <1295871227-2545-2-git-send-email-jacob@internet24.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37677 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab1AXUiy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jan 2011 15:38:54 -0500
In-Reply-To: <1295871227-2545-2-git-send-email-jacob@internet24.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 24.01.2011 13:13, schrieb Thomas Jacob:
> iprange_ipv6_sub was substracting 2 unsigned ints and then casting
> the result to int to find out whether they are lt, eq or gt each
> other, this doesn't work if the full 32 bits of each part
> can be used in IPv6 addresses. Patch should remedy that without
> significant performance penalties. Also number of ntohl
> calls can be reduced this way (Jozsef Kadlecsik).

This looks fine to me, applied with a minor cosmetic change
(space before opening parens after if). Thanks Thomas.
