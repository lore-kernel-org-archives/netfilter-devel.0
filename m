From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [PATCH] Re: [ULOGD RFC 08/30] NFCT: rework
Date: Sat, 02 Feb 2008 21:07:34 +0100
Message-ID: <8763x7jf5l.fsf@kruemel.eitzenberger.org>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
	<20080130190127.400747893@kruemel.intranet.astaro.de>
	<20080202162037.GA16826@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:51354 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759872AbYBBUHl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:07:41 -0500
In-Reply-To: <20080202162037.GA16826@localhost> (Eric Leblond's message of
 "Sat, 2 Feb 2008 17:20:37 +0100")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond <eric@inl.fr> writes:

Hi Eric,

> You changelog is not complete as it did not mention important
> modification of the output keys.

Sorry, my way of presenting all those changes in very few patches was
intentional, I just tried to keep the number of patches small.

> Accounting is done here for both side of connection ...

Yes, principally this should be a configuration option sooner or later,
but this is what I needed at the time of writing that patch.  The former
way might not be what someone would expect though.  But sure, that change
should have been documented somewhere.

I'll provide a patchset which stuffs all NFCT-related patches into one.
Therein contained are two small changes which basically root from
Pablo Neiras suggestions.

As my NFCT changes currently still depend on one small patch to
libnetfilter-conntrack and Pablo seems quite reluctant to apply that
I'll suggest in my next announcement to apply all but the NFCT changes.
I would like to solve that issue by switching to libnl soon.

However, that switch only makes sense if the other netlink users (NFLOG,
ifi) are switched as well.

If Patrick decides to apply that big patch (retaining compatibility of
output keys of course) I'm fine.  If not I would have to do a gradual
switch to the new code base, but then preferably switching to libnl on
the go.

Thanks for reviewing!

 /holger

