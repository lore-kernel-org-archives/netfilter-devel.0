From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] netfilter: NFQUEUE use NFPROTO_UNSPEC
Date: Fri, 05 Jun 2009 13:19:02 +0200
Message-ID: <4A28FF26.7070101@trash.net>
References: <1244164542-10739-1-git-send-email-fw@strlen.de> <1244164542-10739-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55168 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbZFELTE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 07:19:04 -0400
In-Reply-To: <1244164542-10739-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal wrote:
> We can use wildcard matching here, just like
> ab4f21e6fb1c09b13c4c3cb8357babe8223471bd ("xtables: use NFPROTO_UNSPEC
> in more extensions").

Applied, thanks.
