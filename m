From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3 nfnetlink_acct] numerous changes and improvements to
 the kernel code
Date: Fri, 19 Apr 2013 04:04:44 +0200
Message-ID: <20130419020444.GA5605@localhost>
References: <514D9D45.6090804@googlemail.com>
 <20130323151213.GA4925@localhost>
 <515203F6.10503@googlemail.com>
 <20130403104647.GA5464@localhost>
 <515DE46F.9080505@googlemail.com>
 <20130411101803.GA4254@localhost>
 <516A7BE2.2050009@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Michael Zintakis <michael.zintakis@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59072 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967673Ab3DSCE4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Apr 2013 22:04:56 -0400
Content-Disposition: inline
In-Reply-To: <516A7BE2.2050009@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Apr 14, 2013 at 10:50:26AM +0100, Michael Zintakis wrote:
[...]
> > You can modify kernel information if you manage to load a module and
> > have some little knowlege on where to find things in the memory space.
> > Truly, I think you can achive this by protecting the configuration
> > file from changes in your tree and some extra checksumming to follow
> > the track of unexpected changes.
>
> I understand that Pablo, but this is quite a bit far-fetched and, in
> my view, less practical (both in terms of performance as well as
> memory footprint) where compared to just using these 2 properties in
> the kernel where they are protected without the need to write extra
> code.
> 
> With placing these properties into the kernel they will also occupy
> less memory and the performance would be better, compared to if all
> this is done in user space (not to mention possible synchronization
> issues as the code in user space needs to "track" nfacct objects in
> the kernel and do that flawlessly).

Check /etc/iproute2/ files, they all contain mappings and information
that are parsed from user-space utilities in runtime by many utilities
and daemons. Nobody has put that information into the kernel.

And more relevantly, these fields you want to add are bloating the
accounting structure for people that don't want your feature.

Sorry, you have to do this from user-space, you have the
infrastructure and the libraries to make it from there.

[...]
> > I mean that ulogd2 provides the framework for Netfilter's user-space
> > logging. It's pretty extensible. You will surely need to make some
> > changes for what you need, but most of the infrastructure is already
> > there. No need for another separated daemon.
>
> My concern with this is that even though you say it is extensible,
> there will be quite a lot of redesigning and rewriting of code - the
> ulogd2 primary function is to check packets and pipe this through
> various "channels" defined in advance at start up, which is quite
> different from the functionality required by the nfacct daemon.

ulogd2 is a generic framework in user-space for packet logging, it
could be extended relatively easy to support what you need.

[...]
> >> a)
> >> nfnetlink_acct.c::nfnl_acct_new:
> >> 	if (matching) {
> >> 		if (nlh->nlmsg_flags & NLM_F_REPLACE) {
> >> 			/* reset counters if you request a replacement.	*/
> >> 			atomic64_set(&matching->pkts, 0);
> >> 			atomic64_set(&matching->bytes, 0);
> > 
> > We should check there if that acct object is in used.
>
> Why? In my opinion, this is not necessary. The replace "mode" can be
> needed in both cases: where refcnt > 0 (nfacct object is used) and
> also where refcnt == 0 (nfacct object is not used). I don't see why
> do we need to make that distinction - we should be able to replace
> nfacct properties regardless of whether that object is used (in
> other words, regardless of the value of refcnt).

You have the operation to atomically dump and reset counters that are
in used via NFNL_MSG_ACCT_GET_CTRZERO with the NLM_F_DUMP flag set (or
nfacct list reset in case you want to use the command line utility).
That allows you to fetch the counters while resetting them, without
leaking counter information.

[...]
> By "lockless" you mean using atomic-types? They aren't "lockless"
> since the atomic operations do uses a lock.

No. By Lockless I mean per-cpu based counters that require no locking
at all.

Regards.
