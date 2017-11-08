From: Phil Sutter <phil@nwl.cc>
Subject: nft: I broke interactive mode with iface changes
Date: Wed, 8 Nov 2017 11:15:45 +0100
Message-ID: <20171108101545.GV32305@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:59330 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751126AbdKHKPr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Nov 2017 05:15:47 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.89)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1eCNOb-0007ph-Ck
        for netfilter-devel@vger.kernel.org; Wed, 08 Nov 2017 11:15:45 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

When preparing my patch 94a945ffa81b7 ("libnftables: Get rid of explicit
cache flushes"), I missed that 'nft -i' was explicitly dropping the
interface cache after every command, so now it won't recognize interface
changes anymore. Sadly, there is no lightweight method available to
detect an outdated interface cache like we have with ruleset cache, so I
played around a bit with alternatives.

First thing to mention, using the iface cache is considerably faster
than calling if_nametoindex/if_indextoname each time.

OTOH, I'm not sure having interface indexes in rules is a good idea to
begin with: A seemingly obvious rule like e.g. 'oif br0 accept' all of a
sudden stops working if br0 is recreated (typically by restarting
libvirt or whatever manages it). This becomes obvious when inspecting
the rule set (said rule won't print the interface name anymore but just
the ifindex value), but it's something users have to be aware of first.

So given that oifname/iifname expressions should be recommended over
plain oif/iif ones for general-purpose applications, I wonder how
important that interface cache really is and whether there is a relevant
drawback when dropping it.

Getting back to the original issue, I see the following alternatives:

* Drop interface cache altogether.
* Make nft_run_cmd_from_*() drop the interface cache before parsing
  commands.
* Reintroduce a 'drop_cache()' API function for cli.c to call it.

Obviously, I prefer the first one, but would appreciate others' opinions
before sending patches.

Thanks, Phil
