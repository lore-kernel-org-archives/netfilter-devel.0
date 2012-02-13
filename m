From: Darren Willis <djw@google.com>
Subject: Re: [PATCH] DHCPv6 connection tracker helper
Date: Mon, 13 Feb 2012 13:07:18 +0900
Message-ID: <CAFntDkzUvtyKZ1in3tKE4jUyhL5C4p3HmMSCGhMVORxxqJEGGA@mail.gmail.com>
References: <CAFntDkx2SUkCkSbU7sO4OrWqypWQpY-KNgrD-_DgqRSXAGvJZQ@mail.gmail.com>
	<20120210111801.GA9827@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41320 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab2BMEHS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Feb 2012 23:07:18 -0500
Received: by vcge1 with SMTP id e1so2875637vcg.19
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2012 20:07:18 -0800 (PST)
In-Reply-To: <20120210111801.GA9827@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Fri, Feb 10, 2012 at 20:18, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> why not just adding the rule that allows udp traffic for this?

Distros don't seem to want to (see the bug I linked where some red hat
people have decided a module is the way to go). Possibly people are
concerned that such a firewall rule leaves a port open on the local
link permanently (and possibly with an /sbin/dhclient binary, or
similar, listening on it).
DHCPv4 seems to get away with it because, IIRC, it uses raw sockets
and bypasses netfilter completely. So it's still open, but people
don't tend to think/know about it (this isn't really a good thing...)

> I still don't see the need for this extra module if you can get it
> done with iptables itself.

I think it's nice to firewall things as much as is feasible, and this
particular case isn't really complex at all. All this module does (and
all that needs doing) is lets through the first reply to the right
port, and after that normal connection tracking takes care of it.

Possibly in the future conntrack should have some kind of extendable
broadcast/multicast helpers module that can set up simple helpers like
this for various different protocols (mDNS, etc)
