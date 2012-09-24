From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] netfilter: have r->cost != 0 case work
Date: Mon, 24 Sep 2012 23:30:56 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1209242321100.25814@nerf07.vanv.qr>
References: <alpine.LNX.2.01.1209221003280.3512@nerf07.vanv.qr> <1348302412-2811-1-git-send-email-jengelh@inai.de> <58f14b4c-67ab-48aa-bbaf-3ce244500b93@email.android.com> <5060C3F2.9020901@infoblox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jim Robinson <jrobinson@infoblox.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:36933 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861Ab2IXVa6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Sep 2012 17:30:58 -0400
In-Reply-To: <5060C3F2.9020901@infoblox.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2012-09-24 22:34, Jim Robinson wrote:
>
>Can you possibly elaborate on why my initial patch does not actually
>fix the problem? Specifically, the concern seems to be that the
>values in 'r->master' in limit_mt_check() may not be reliable. In my
>testing I saw that r->master was the same (both address and values)
>as had been being used in limit_mt() calls for the rule.

The ruleset may have already changed by the time the iptables
userspace process gets to send in the modified ruleset (with
an old r->master).

1. iptables instance 1 fetches ruleset
2. iptables instance 2 flushes the ruleset
3. iptables instance 1 reuploads the ruleset, now with a
   r->master pointing into the woods.
4. ???
5. boom.

Or, for extra giggles:

1. iptables instance 1 fetches ruleset
2. iptables instance 1 uploads ruleset
3. the new temporary table, i.e. the limit match inside it,
   (wrongly) reuses r->master
4. the old table frees all its private data.
   the new limit rule's r->master now points into the woods.
5. ???
6. boom.

>And as something of an aside, can you say why limit_mt_check() is called on all
>the rate limit rules when an unrelated iptables change occurs? This is what I
>observed.

First the new table is constructed, then atomically swapped with
the old one, after which the old one is freed.
