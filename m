From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 017/103] netfilter: xtables: use better unconditional
 check
Date: Mon, 10 Aug 2009 10:54:09 +0200
Message-ID: <4A7FE031.3090506@trash.net>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de> <1249370787-17583-18-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59198 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZHJIyN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2009 04:54:13 -0400
In-Reply-To: <1249370787-17583-18-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> The use of memcmp should enable architecture-preferred comparison
> methods, for example 64-bit comparisons that would complete in [more
> than] half the time than inspecting just each u32/char.

I don't object to the change as cleanup, but that reasoning makes
no sense. memcmp can't assume alignment, so unless there's a
version checking for compile-time known alignment, this won't happen.

Please fix up the changelog and label this as cleanup.
