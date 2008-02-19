From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD 05/15] Add signalling subsystem
Date: Tue, 19 Feb 2008 20:38:55 +0100
Message-ID: <47BB304F.6030707@netfilter.org>
References: <20080202204826.267107164@astaro.com> <20080202205107.857015672@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, holger@eitzenberger.org
To: heitzenberger@astaro.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55106 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750976AbYBSTjB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:39:01 -0500
In-Reply-To: <20080202205107.857015672@astaro.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

heitzenberger@astaro.com wrote:
> This patch adds the concept of synchronous and asynchronous signal
> handlers to ulogd, where 'synchronous' just means to be synchronous to
> the underlying IO multiplexer.

I just committed a patch that reworks the timer framework to make it
synchronous with select(). Since we don't have asynchronous timers
anymore, I think that we can just block signaling during file
descriptors handling since ulogd would receive not often. AFAICS, this
infrastructure is nice but it was mainly targeted to the annoying SIGALRM.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
