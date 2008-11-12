From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2 v2] New netfilter target to trigger LED devices
Date: Wed, 12 Nov 2008 11:42:11 +0100
Message-ID: <491AB303.7000500@netfilter.org>
References: <49196D12.1030803@shikadi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35161 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750843AbYKLKmS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Nov 2008 05:42:18 -0500
In-Reply-To: <49196D12.1030803@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adam Nielsen wrote:
> Add a new "LED" target to iptables, which allows LEDs to blink in
> response to matching rules.

I did not have a look in deep into your patch but the first questions
that comes to my mind is, how many people can benefit from this LED
target? What is its real application?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
