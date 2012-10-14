From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv3] conntrackd: make conntrackd namespace aware
Date: Sun, 14 Oct 2012 23:48:19 +0200
Message-ID: <20121014214819.GA831@1984>
References: <1349315351-6689-1-git-send-email-aatteka@nicira.com>
 <20121010223556.GA6160@1984>
 <CAMQa7Bg9Wf1emNYnS9J4375d4Xhrs7NLRuj2ZBJD==hbXGBMTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ansis Atteka <aatteka@nicira.com>, netfilter-devel@vger.kernel.org
To: Ansis Atteka <ansisatteka@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39088 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab2JNVsZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Oct 2012 17:48:25 -0400
Content-Disposition: inline
In-Reply-To: <CAMQa7Bg9Wf1emNYnS9J4375d4Xhrs7NLRuj2ZBJD==hbXGBMTA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 12, 2012 at 07:02:01PM -0700, Ansis Atteka wrote:
> On 10 October 2012 15:35, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hi Ansis,
> >
> > On Wed, Oct 03, 2012 at 06:49:10PM -0700, Ansis Atteka wrote:
> >> This patch allows conntrackd to open CT Netlink sockets into a given
> >> network namespace. Channel sockets (e.g. UDP) would still be opened into
> >> the same namespace where conntrackd was started.
> >>
> >> The only binary this patch affects is conntrackd. All other binaries (e.g.
> >> conntrack, nfct) would still operate in the same namespace where they were
> >> started.
> >>
> >> To make use of this patch:
> >> 1. create a network namespace: "ip netns add the_ns"
> >> 2. add "NetlinkNamespace /var/run/netns/the_ns" line to the conntrackd.conf
> >> file inside General {...} section.
> >
> > I want to apply this, but user-space helpers got broken with this:
> >
> > [Thu Oct 11 00:31:13 2012] (pid=12400) [ERROR] could not switch to namespace: Invalid argument
> >
> > You can use conntrack-tools/doc/helper/conntrackd.conf as example.
> >
> > You also need to use a Linux kernel 3.6 to test this user-space helper
> > feature, see: http://conntrack-tools.netfilter.org/manual.html#helpers
> 
> After a quick try to configure user-space helpers, I am seeing following error:
> 
> root@aatteka-virtual-machine:~# uname -r
> 3.6.0-030600-generic
> root@aatteka-virtual-machine:~# nfct helper add rpc inet tcp
> nfct v1.2.2: error: Invalid argument
> root@aatteka-virtual-machine:~# nfct helper list
> nfct v1.2.2: error: Invalid argument
> 
> gdb tells me that this is response on NFNL_MSG_CTHELPER_[GET|NEW]
> messages. Am I missing something when registering user-space helpers?

Did you forget to compile your kernel with CONFIG_NF_CT_NETLINK_HELPER ?

nfnetlink returns -EINVAL for unexistent subsystems (we should change
it to a better error code actually).

IIRC nfnetlink_cthelper should be autoloaded automatically. Not need
to explicitly modprobe it.
