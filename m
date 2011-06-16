From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter/ip_tables: fix compile with debug
Date: Thu, 16 Jun 2011 17:17:19 +0200
Message-ID: <4DFA1E7F.8000205@trash.net>
References: <1308169381-10067-1-git-send-email-sebastian@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59800 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab1FPPRU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:17:20 -0400
In-Reply-To: <1308169381-10067-1-git-send-email-sebastian@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15.06.2011 22:23, Sebastian Andrzej Siewior wrote:
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

Applied, thanks. We should really convert this stuff to pr_debug to
make sure these problems are found even without debugging enabled.
