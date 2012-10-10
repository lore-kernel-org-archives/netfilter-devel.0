From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv3] conntrackd: make conntrackd namespace aware
Date: Thu, 11 Oct 2012 00:35:56 +0200
Message-ID: <20121010223556.GA6160@1984>
References: <1349315351-6689-1-git-send-email-aatteka@nicira.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ansis Atteka <aatteka@nicira.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38887 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756906Ab2JJWgB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:36:01 -0400
Content-Disposition: inline
In-Reply-To: <1349315351-6689-1-git-send-email-aatteka@nicira.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Ansis,

On Wed, Oct 03, 2012 at 06:49:10PM -0700, Ansis Atteka wrote:
> This patch allows conntrackd to open CT Netlink sockets into a given
> network namespace. Channel sockets (e.g. UDP) would still be opened into
> the same namespace where conntrackd was started.
> 
> The only binary this patch affects is conntrackd. All other binaries (e.g.
> conntrack, nfct) would still operate in the same namespace where they were
> started.
> 
> To make use of this patch:
> 1. create a network namespace: "ip netns add the_ns"
> 2. add "NetlinkNamespace /var/run/netns/the_ns" line to the conntrackd.conf
> file inside General {...} section.

I want to apply this, but user-space helpers got broken with this:

[Thu Oct 11 00:31:13 2012] (pid=12400) [ERROR] could not switch to namespace: Invalid argument

You can use conntrack-tools/doc/helper/conntrackd.conf as example.

You also need to use a Linux kernel 3.6 to test this user-space helper
feature, see: http://conntrack-tools.netfilter.org/manual.html#helpers
