From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH r7363 4/5] use list_for_each_entry()
Date: Thu, 14 Feb 2008 15:22:33 +0100
Message-ID: <47B44EA9.4000701@netfilter.org>
References: <20080213171046.29912.41091.stgit@woodpecker.roonstrasse.net> <20080213171327.29912.91893.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56542 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752315AbYBNOWl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Feb 2008 09:22:41 -0500
In-Reply-To: <20080213171327.29912.91893.stgit@woodpecker.roonstrasse.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
> since alarm_run_queue is now a local variable, we can use the faster
> list_for_each_entry() instead of list_for_each_entry_safe() /
> list_del().

Applied. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
