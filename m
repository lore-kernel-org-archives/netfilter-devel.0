From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/4] call __run() after do_alarm_run()
Date: Tue, 22 Jan 2008 02:30:14 +0100
Message-ID: <47954726.2060101@netfilter.org>
References: <20080121082752.27612.82519.stgit@rabbit.intern.cm-ag> <20080121082958.27612.90493.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50286 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754030AbYAVBa3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 20:30:29 -0500
In-Reply-To: <20080121082958.27612.90493.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
> this saves us the initialization.  this patch is re-sent, it was first
> submitted on january 18th.

Applied. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
