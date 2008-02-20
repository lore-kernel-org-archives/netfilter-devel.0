From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD 05/15] Add signalling subsystem
Date: Wed, 20 Feb 2008 13:23:12 +0100
Message-ID: <47BC1BB0.9020106@netfilter.org>
References: <20080202204826.267107164@astaro.com> <20080202205107.857015672@astaro.com> <47BB304F.6030707@netfilter.org> <47BBE821.7070909@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, holger@eitzenberger.org
To: Holger Eitzenberger <heitzenberger@astaro.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39865 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751236AbYBTMX2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Feb 2008 07:23:28 -0500
In-Reply-To: <47BBE821.7070909@astaro.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Holger Eitzenberger wrote:
> comparing your patch with the one I provided in my last patch collection
> I can say that your patch is quite larger due to the usage of the
> red-black trees in the timer code.  The number of timers in ulogd is
> depending of your configuration of course, but with my current
> configuration (NFLOG, NFCT, SQLITE3) I have currently three timers, wow.
> 
> Note that with your patch you basically remove the possibility for
> plugins to have timers which are asynchronous.  It's therefore less
> flexible for future users.

Please, could you tell me why my timer approach is less flexible?

> Also note that libraries such as libevent do it quite similar than
> provided in my patch.

Indeed. This was the intention of my patch, to make ulogd event-driven
and so timers synchronous using select() which simplifies the timer
infrastructure instead of using SIGALRM.

> My patch has the intention of providing a flexible infrastructure for
> plugins, which room for future improvements (such as red-black trees if
> there are hundreds of timers).   Some of my later patches I have
> enqueued locally base on those changes, but that's my problem.
> 
> You commented on some of those patches, with a quite positive statement
> to my initial post of this patch.  Also, Eric gave a GO on all patches
> despite the last NFCT patch, which I promised to rework for
> compatibility reason and based on your suggestions.

I have barely touched NFCT. I'm still waiting for your NFCT patch.

> I accept the fact that you apparently like red-black trees and they
> definitely have their use-cases, but looking at typical ulogd
> configurations and numbers of timers in ulogd I can say that red-black
> trees just for timer usage seem to me like overkill.

We can easily implement list-based timers using the same API. You only
have to use the current timer API in your patches.

> Since you are in the habit of favoring your own patches against the ones
> I provide, even without giving a chance to modify my patch, I simply
> consider doing a fork of ulogd.

You still have the chance to modify your patches. I'm not disregarding
your work.

> Otherwise I'll loose many of the work I've enqueued locally.

I have kept lots of patches locally in my whole life that I had rework
lots of times to get them into mainline...

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
