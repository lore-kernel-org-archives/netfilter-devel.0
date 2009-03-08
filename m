From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ANNOUNCE] ulogd 2.0.0beta3
Date: Sun, 08 Mar 2009 13:45:54 +0100
Message-ID: <49B3BE02.9010203@netfilter.org>
References: <49B166E0.7030201@netfilter.org> <20090307103406.GB4678@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38542 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751607AbZCHMqI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Mar 2009 08:46:08 -0400
In-Reply-To: <20090307103406.GB4678@prithivi.gnumonks.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Harald Welte wrote:
> Hi guys,
> 
> congratulations on the new beta release.
> 
> On Fri, Mar 06, 2009 at 07:09:36PM +0100, Pablo Neira Ayuso wrote:
>>       Link ulogd2 with libpthread
> 
> I was just reading this and all alarm sirens went on.  I don't know
> why that is neccessary, and I hope it is just due to some library dependency.
> 
> When I created ulogd and ulogd2, I never intended them to become some kind of
> multi-threaded monster with a complex locking and synchronization nightmare.

Please, don't worry, I will not allow such a crappy design change :)

The conntrack-tools follows the sample principle. I don't know if you
had the time to look at the code, but for example, we removed another
tricky issue from the synchronization point of view time ago which was
the use of SIGALARM to implement the timer framework. So this whole
thing now follows an event-driven design with a synchrnous alarm
framework to avoid complexity as expected.

> Sure, I'm no longer maintaining it, and I respect the decision of current
> maintainers, but I just wanted to point that out.

As said, it seems that the patch was applied by Pierre (via Eric) due to
some very kiddish reason, please, set alarms off :).

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
