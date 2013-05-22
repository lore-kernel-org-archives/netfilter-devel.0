From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xtables: Add locking to prevent concurrent instances
Date: Wed, 22 May 2013 21:29:06 +0200
Message-ID: <65164901-9a18-4349-973f-6b541beba6b3@email.android.com>
References: <20130522173511.GB860@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: Phil Oester <kernel@linuxace.com>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47212 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab3EVT3r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 May 2013 15:29:47 -0400
In-Reply-To: <20130522173511.GB860@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Phil Oester <kernel@linuxace.com> schrieb:

>There have been numerous complaints and bug reports over the years when
>admins
>attempt to run more than one instance of iptables simultaneously. 
>Currently
>open bug reports which are related:
>
>325: Parallel execution of the iptables is impossible
>758: Retry iptables command on transient failure
>764: Doing -Z twice in parallel breaks counters
>822: iptables shows negative or other bad packet/byte counts
>
>As Patrick notes in 325:  "Since this has been a problem people keep
>running
>into, I'd suggest to simply add some locking to iptables to catch the
>most
>common case."
>
>I started looking into alternatives to add locking, and of course the
>most
>common/obvious solution is to use a pidfile.  But this has various
>downsides,
>such as if the application is terminated abnormally and the pidfile
>isn't
>cleaned up.  And this also requires a writable filesystem.  Using a
>UNIX domain
>socket file (e.g. in /var/run) has similar issues.
>
>Starting in 2.2, Linux added support for abstract sockets.  These
>sockets
>require no filesystem, and automatically disappear once the application
>terminates.  This is the locking solution I chose to implement in
>xtables-multi.
>As an added bonus, since each network namespace has its own socket
>pool, an
>iptables instance running in one namespace will not lock out an
>iptables
>instance running in another namespace.  A filesystem approach would
>have
>to recognize and handle multiple network namespaces.
>
>As long as I was adding locking, I also chose to add a retry loop, with
>3
>attempts made to grab the lock before giving up.

If I'm not mistaken, we retry failed operations since a few years now, so is this actually still a problem? 

If so, why abort after three tries instead of waiting until the lock can be acquired?


