From: Holger Eitzenberger <heitzenberger@astaro.com>
Subject: Re: [ULOGD 05/15] Add signalling subsystem
Date: Wed, 20 Feb 2008 09:43:13 +0100
Message-ID: <47BBE821.7070909@astaro.com>
References: <20080202204826.267107164@astaro.com> <20080202205107.857015672@astaro.com> <47BB304F.6030707@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, holger@eitzenberger.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-12.dex002.intermedia.net ([64.78.21.79]:47238 "EHLO
	dhost002-12.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761307AbYBTInU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Feb 2008 03:43:20 -0500
In-Reply-To: <47BB304F.6030707@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:

>> This patch adds the concept of synchronous and asynchronous signal
>> handlers to ulogd, where 'synchronous' just means to be synchronous to
>> the underlying IO multiplexer.
> 
> I just committed a patch that reworks the timer framework to make it
> synchronous with select(). Since we don't have asynchronous timers
> anymore, I think that we can just block signaling during file
> descriptors handling since ulogd would receive not often. AFAICS, this
> infrastructure is nice but it was mainly targeted to the annoying SIGALRM.

Hi Pablo,

comparing your patch with the one I provided in my last patch collection 
I can say that your patch is quite larger due to the usage of the 
red-black trees in the timer code.  The number of timers in ulogd is 
depending of your configuration of course, but with my current 
configuration (NFLOG, NFCT, SQLITE3) I have currently three timers, wow.

Note that with your patch you basically remove the possibility for 
plugins to have timers which are asynchronous.  It's therefore less 
flexible for future users.

Also note that libraries such as libevent do it quite similar than 
provided in my patch.

My patch has the intention of providing a flexible infrastructure for 
plugins, which room for future improvements (such as red-black trees if 
there are hundreds of timers).   Some of my later patches I have 
enqueued locally base on those changes, but that's my problem.

You commented on some of those patches, with a quite positive statement 
to my initial post of this patch.  Also, Eric gave a GO on all patches 
despite the last NFCT patch, which I promised to rework for 
compatibility reason and based on your suggestions.

I accept the fact that you apparently like red-black trees and they 
definitely have their use-cases, but looking at typical ulogd 
configurations and numbers of timers in ulogd I can say that red-black 
trees just for timer usage seem to me like overkill.

Since you are in the habit of favoring your own patches against the ones 
I provide, even without giving a chance to modify my patch, I simply 
consider doing a fork of ulogd.  Otherwise I'll loose many of the work 
I've enqueued locally.

Patrick?

  /holger


-- 
Holger Eitzenberger <heitzenberger@astaro.com> | Software Developer
Astaro AG | www.astaro.de | Phone +49-721-25516-246 | Fax -200

Download your free 30 day trial version of the award-winning Astaro
Security Gateway solution here: https://my.astaro.com/download/
