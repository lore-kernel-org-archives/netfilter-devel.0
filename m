From: Maximilian Wilhelm <max@rfc2324.org>
Subject: Re: ct_sync project update
Date: Fri, 6 Feb 2009 18:26:42 +0100
Message-ID: <20090206172641.GH30540@outback.rfc2324.org>
References: <498C6996.5060004@usherbrooke.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rfc2324.org ([89.149.194.216]:59669 "EHLO rfc2324.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbZBFSEG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:04:06 -0500
Received: from max by rfc2324.org with local rfc2324.org Mailserver
	id 1LVUTS-0006oD-7R
	for <netfilter-devel@vger.kernel.org>; Fri, 06 Feb 2009 18:26:42 +0100
Content-Disposition: inline
In-Reply-To: <498C6996.5060004@usherbrooke.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Anno domini 2009 David Goulet scripsit:

Hi!

> For a University Project, I'm trying to take back the ct_sync
> project and make it work on >= linux kernel 2.6.26. The last patches
> I found are for linux 2.6.10 and much have changed since then. They
> are no longer applicable unless major changes.

I some time ago[tm] made up patches for 2.6.15/16.
If you *really* want to go for ct_sync, you might want to have a look
at http://files.rfc2324.org/patches/ct_sync/

> Is there any other group or "hidden svn" that maintain or contain up
> to date stuff?
> What's your best advice guys for this project? Is it realistic to
> take it back or not?

Why do you want to?
The user space deamon conntrackd has been developed and evolved as a
successor of ct_sync and can be used with any current kernel
supporting netlink without patching.

Ciao
Max
-- 
	Follow the white penguin.
