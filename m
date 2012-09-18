From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrackd: make conntrackd namespace aware
Date: Tue, 18 Sep 2012 21:23:20 +0200
Message-ID: <20120918192320.GA1182@1984>
References: <1346461915-6309-1-git-send-email-aatteka@nicira.com>
 <20120906170253.GA17317@1984>
 <CAA=3Oq=G9g=9LkKxhobU1cTLtU3jyuGJZn4kn_E4LJXk11Escw@mail.gmail.com>
 <20120911154458.GB28012@1984>
 <CAA=3Oqm_tGgKpWf2V=Ki7Le-UcA7o_-_o+77TRjPX6-4RYha2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ansis Atteka <aatteka@nicira.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51086 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011Ab2IRTXY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Sep 2012 15:23:24 -0400
Content-Disposition: inline
In-Reply-To: <CAA=3Oqm_tGgKpWf2V=Ki7Le-UcA7o_-_o+77TRjPX6-4RYha2Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 13, 2012 at 12:37:18AM -0700, Ansis Atteka wrote:
[...]
> I know that this would be a massive change, so I might miss
> something in the proposal. Anyway feel free to correct me or ask for
> more details where necessary. Here is a list of necessary changes:
> 
> 1. Quite a lot of refactoring in configuration parser.
> 
> I would suggest to split ct_conf struct into three logical pieces (i.e. smaller
> structs):
> a. channel config (instance per remote conntrackd instance)
> b. conntrack-state config (instance per namespace)
> c. static/global config (single instance; Would contain path to log
> file, unix socket e.t.c.)

I always wanted to clean up ct_conf. See patch attached, I didn't
commit it yet since I want to give it some test (Please, not need to
rebase the patch we're currently discussing upon it).

> This decoupling would allow much more easily to maintain relation
> between conntrack-states and channels (for example, when multiple
> namespaces are using the same channel).

I'm not familiar with the channel definition you're using.

Note that conntrackd already uses the name `channel' for the state-sync
link abstraction (ie. TCP / UDP / MCAST / TIPC ...).

> Also, currently CONFIG(X) macro allows to reference only a single ct_conf
> instance. This will need to be changed so that each namespace has its own
> ct_conf_sync instance. And each channel has its own ct_conf_channel instance.
> 
> Also, I am afraid that, for this to make more sense, I would have to extend
> conntrackd.conf syntax, For example,introduce following top-level sections:
> channel {}, sync {} and global {} respectively.
> 
> 2. Allow to add, remove and list configuration dynamically without
> restarting conntrackd. This would require ability to start conntrackd
> with minimal global/static configuration. After that add namespaces and
> channel configuration by using Unix Domain socket.
> 
> For example, instead of starting conntrackd with following command:
> conntrackd -C /etc/conntrackd/conntrackd.conf
> 
> One would have to use something like this:
> conntrackd --global-config /etc/conntrackd/conntrackd_global.conf #
> This config file would just specify Unix socket, log file e.t.c.
> and then on-the-fly add channel and namespace configuration with:
> conntrackd -U /var/run/conntrackd.ctl --add
> /etc/conntrackd/conntrackd_namespace1.conf
> conntrackd -U /var/run/conntrackd.ctl --add
> /etc/conntrackd/conntrackd_channel1.conf
> conntrackd -U /var/run/conntrackd.ctl --add
> /etc/conntrackd/conntrackd_namespace2.conf
> conntrackd -U /var/run/conntrackd.ctl --add
> /etc/conntrackd/conntrackd_channel2.conf
> 
> We could glue namespaces together with channels by using some IDs.
> 
> Another question is, whether over the Unix domain socket we would prefer to
> transfer binary (already parsed) or textual (yet unparsed) configuration?
> 
> Also, I would need to figure out if/how to maintain backward compatibility with
> already existing commands, when there are multiple namespaces (e.g. dump
> internal cache, commit external cache ...).
> 
> 3. Wire protocol format improvements, so that namespace ID would be encapsulated
> into the protocol too. This is required, when same channel is being
> used by multiple namespaces.

This only requires adding one new TLV attribute to identify this. So
we don't need to bloat the header with one field that is not use.

> 4. Similarly as CONFIG(x) was broken down into 3 logical pieces, the
> same thing would
> need to be done for STATE(x) macros.

This seems to be a huge changeset what you're proposing.

I need some convincing architecture example that describes how this
can be used before you submit such a big patch. I need to understand
it to know if there is a different way to make this.
