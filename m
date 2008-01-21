From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/4] __run() returns void
Date: Mon, 21 Jan 2008 14:22:24 +0100
Message-ID: <47949C90.5000705@netfilter.org>
References: <20080121082752.27612.82519.stgit@rabbit.intern.cm-ag> <20080121082958.27612.59754.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45064 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752249AbYAUNWo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 08:22:44 -0500
In-Reply-To: <20080121082958.27612.59754.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
>  src/run.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)

I have kept back 3/4 and 4/4 until we find the issue with patch 2/4.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
