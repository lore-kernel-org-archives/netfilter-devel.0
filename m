From: James Nurmi <jdnurmi@qwe.cc>
Subject: IPTables API (redux)
Date: Sat, 11 Dec 2010 15:42:17 -0800
Message-ID: <AANLkTinphM_EPoFVWm63qXEpvFZzUuMjrOVyMx7S-ArW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64550 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab0LKXmS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Dec 2010 18:42:18 -0500
Received: by vws16 with SMTP id 16so2926569vws.19
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Dec 2010 15:42:18 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I realize this has come up a few times, but I'd like to
programmatically be able to  query and modify IPTables rules, without
shelling out.

After digging, it would seem theres been some discussion around this
issue, but I was unable to find any resolution.

Background: the reason is was a hope to write native bindings for Go
for certain chain/table manipulation tasks.

For curiosities sake, I did a bit of reverse engineering and
discovered that the functionality I'm interested in appears to be
handled through set/getsockopt and requires a large amount of handling
for both COMPAT and not COMPAT kernel compilations, leading to
structures potentially being packed differently on the way in then on
the way out, so a "trivial" implementation was just out as far as I
could tell.

While I can successfully communicate with the  netlink (iptables and
not) modules via some custom work, I've been unable to find anything
but references to desires for an NL layer to communicate with IPtables
rather than the get/setsockopt channels, and the general opinion that
"you're doing it wrong if you want this", but just in case there were
hidden developments, I thought I'd poke.

And while it's unlikely I'd be the one to do it, is there a good
technical reason to not have netlink handling the table/chain
manipulation rather than opaque get/set sockopts?

Cheers,
James
