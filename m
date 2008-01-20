From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-failover] [conntrack-utils PATCH r7254 01/14] merge mod_alarm()
 into add_alarm()
Date: Mon, 21 Jan 2008 00:53:47 +0100
Message-ID: <4793DF0B.9000702@netfilter.org>
References: <20080118104935.4444.26673.stgit@woodpecker.roonstrasse.net> <20080118105309.4444.14927.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38929 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753767AbYATXyL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 18:54:11 -0500
In-Reply-To: <20080118105309.4444.14927.stgit@woodpecker.roonstrasse.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
>  include/alarm.h   |    4 +---
>  src/alarm.c       |   13 +++++--------
>  src/cache_timer.c |    5 ++---
>  src/sync-alarm.c  |   17 +++++++----------
>  src/sync-ftfw.c   |    8 +++-----
>  5 files changed, 18 insertions(+), 29 deletions(-)

Applied a similar version. Thanks.

BTW, I'm cc'ing to both netfilter-devel and netfilter-failover, next
time just include netfilter-devel since we're discussing development stuff.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
