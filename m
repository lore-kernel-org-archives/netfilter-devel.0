From: Max Kellermann <max@duempel.org>
Subject: Re: [conntrack-utils PATCH r7285 04/11] added alarm_pending()
Date: Wed, 23 Jan 2008 12:58:31 +0100
Message-ID: <20080123115831.GA14427@swift.blarg.de>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag> <20080122141051.30077.28791.stgit@rabbit.intern.cm-ag> <479729ED.6070904@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:56446 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751071AbYAWL6c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2008 06:58:32 -0500
Content-Disposition: inline
In-Reply-To: <479729ED.6070904@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2008/01/23 12:50, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Max Kellermann wrote:
> > +int alarm_pending(struct alarm_list *alarm, struct timeval *tv)
> > +{
> > +	if (list_empty(&alarm->head))
> > +		return 0;
> > +
> > +	if (tv != NULL)
> > +		*tv = alarm->tv;
> 
> This introduces an extra copy.

I know.  This patch should make transition to libevent smooth.
libevent still has this copy in evtimer_pending(), but it is called
rarely, and libevent does not do a lookup in 2048 lists in every main
loop iteration.

> > +	if (!alarm_pending(alarm, &tmp))
> > +		return 0;
> 
> I cannot think of a situation where alarm_pending returns true at the
> moment.

You mean, where alarm_pending returns false?  The check is just here
for completeness, you could replace it with an assertion.

Max

