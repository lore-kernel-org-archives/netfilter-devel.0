From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/4] don't ignore fd events when an alarm is due
Date: Tue, 22 Jan 2008 02:29:33 +0100
Message-ID: <479546FD.4020505@netfilter.org>
References: <20080121082752.27612.82519.stgit@rabbit.intern.cm-ag> <20080121082958.27612.37473.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50143 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752623AbYAVB3v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 20:29:51 -0500
In-Reply-To: <20080121082958.27612.37473.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
> also, pass &next_alarm to __run() only if there is an alarm; eliminate
> the "timeout" parameter; the alarm functions get_next_alarm_run() and
> do_alarm_run() return an timeval pointer instead of a boolean.

Applied with the missing ! in timerisset(). Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
