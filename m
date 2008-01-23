From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-utils PATCH r7285 07/11] use size_t
Date: Wed, 23 Jan 2008 13:58:49 +0100
Message-ID: <47973A09.4090207@netfilter.org>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag> <20080122141051.30077.59792.stgit@rabbit.intern.cm-ag> <47973346.9060404@netfilter.org> <20080123123746.GA18405@swift.blarg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56440 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752217AbYAWM7H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2008 07:59:07 -0500
In-Reply-To: <20080123123746.GA18405@swift.blarg.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
> On 2008/01/23 13:29, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> I have kept remain signed since a malformed header can result in an
>> overflow.
> 
> How?  And how will making it signed help?

Indeed. This doesn't make any sense. I thought that if net->len may be
bigger than remain, thus remain becomes negative and we stop looping.
But this condition is never true since we have already checked that
net->len <= remain in the beginning of the loop. I have changed remain
to size_t.

-- 
"Los honestos son inadaptados sociales" -- Les Luthies
