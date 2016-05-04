From: Florian Westphal <fw@strlen.de>
Subject: Re: Kernel crash on helper module unload
Date: Thu, 5 May 2016 01:28:47 +0200
Message-ID: <20160504232847.GC13568@breakpoint.cc>
References: <CAPWQB7H6jt-TnsFH+dxNRAosPYYZmoKCc+C+b=pR+p4CxmtzvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jarno Rajahalme <jarno@ovn.org>
To: Joe Stringer <joe@ovn.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53547 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753952AbcEDX2v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 May 2016 19:28:51 -0400
Content-Disposition: inline
In-Reply-To: <CAPWQB7H6jt-TnsFH+dxNRAosPYYZmoKCc+C+b=pR+p4CxmtzvQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Joe Stringer <joe@ovn.org> wrote:
> Hi all,
> 
> I've noticed that you can crash the kernel by running FTP traffic
> through to a netns, then removing the FTP helper module from the host.
> Repro involves setting automatic helpers (default up until nf-next),
> running an FTP client in one netns through to a server in another
> netns with linux bridge providing L2 connectivity in between. If you
> remove the namespaces after running traffic, then the netns cleanup +
> hook unregistration is deferred to a workqueue. If you can unload the
> FTP helper module before this code triggers, then the work item will
> attempt to destroy helpers that were provided by the (now unloaded)
> module. This piece fails, causing the BUG.
> 
> I've boiled it down to a repro script here:
> https://gist.github.com/joestringer/465328172ee8960242142572b0ffc6e1
> 
> The FTP server used within is a simple python application here,
> requires pyftpdlib:
> https://github.com/openvswitch/ovs/blob/v2.5.0/tests/test-l7.py

Thanks.

> Other dependencies are standard things like conntrack, ip, bridge-utils, wget.
> 
> In regards to affected kernels, I looked back as far as 3.13 and I can
> still reproduce the issue with the above script.
> 
> Here's the kernel backtrace:
> 
> [  136.808116] BUG: spinlock lockup suspected on CPU#0, kworker/u256:30/160
> [  136.808294]  lock: 0xffff880069fd6400, .magic: dead4ead, .owner:
> kworker/u256:30/160, .owner_cpu: 0

[..]

AFAIU following happens:

1. ct is created with ftp helper in netns x
2. netns x gets destroyed
3. netns destruction is scheduled
4. netns destruction wq starts, removes netns from global list
5. ftp helper is unloaded, which resets all helpers of the conntracks

... but because netns is already gone from list the for_each_net() loop
doesn't include it, so we do not change any of the conntracks in net
namespaces that are already dead.

5. netns destruction invokes destructor for rmmod'ed helper

Main problem is that the netns unification doesn't fully resolve this
problem, as the confirmed lists are still part of the net namespace,
i.e. a helper assigned to a conntrack entry that isn't in the table, but
sitting on unconfirmed list would also trigger this bug.

I'm afraid this is similar mess as the one fixed in
commit 200b916f3575bdf11609cb447661b8d5957b0bbf
Author: Cong Wang <cwang@twopensource.com>
Date:   Mon May 12 15:11:20 2014 -0700

    rtnetlink: wait for unregistering devices in rtnl_link_unregister()

And we probably need to play games w. net_mutex :-|

