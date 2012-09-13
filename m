From: Ansis Atteka <aatteka@nicira.com>
Subject: Re: [PATCH] conntrackd: make conntrackd namespace aware
Date: Thu, 13 Sep 2012 00:37:18 -0700
Message-ID: <CAA=3Oqm_tGgKpWf2V=Ki7Le-UcA7o_-_o+77TRjPX6-4RYha2Q@mail.gmail.com>
References: <1346461915-6309-1-git-send-email-aatteka@nicira.com>
	<20120906170253.GA17317@1984>
	<CAA=3Oq=G9g=9LkKxhobU1cTLtU3jyuGJZn4kn_E4LJXk11Escw@mail.gmail.com>
	<20120911154458.GB28012@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:37647 "HELO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751635Ab2IMHhV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:37:21 -0400
Received: by wgbfm10 with SMTP id fm10so335923wgb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Sep 2012 00:37:19 -0700 (PDT)
In-Reply-To: <20120911154458.GB28012@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 11, 2012 at 8:44 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Sep 10, 2012 at 04:24:49PM -0700, Ansis Atteka wrote:
> [...]
>> >
>> >> +
>> >> +#ifdef __NR_setns
>> >> +
>> >> +static int root_fd = -1;
>> >
>> > This root_fd should go to STATE(ns).root_fd:
>>
>> Right, it makes more sense to put it inside ct_state for
>> now.
>>
>> Once conntrackd will become multi-namespace
>> aware, we will have to move it somewhere else,
>> because all the namespaces(i.e. ct_states) will
>> use the same root_fd.
>
> Can you develop a bit more the change that should happen in your
> opinion) to conntrackd to support multi-namespace? I'd like to get an
> idea before that patch lands on the mailing list.
I know that this would be a massive change, so I might miss
something in the proposal. Anyway feel free to correct me or ask for
more details where necessary. Here is a list of necessary changes:

1. Quite a lot of refactoring in configuration parser.

I would suggest to split ct_conf struct into three logical pieces (i.e. smaller
structs):
a. channel config (instance per remote conntrackd instance)
b. conntrack-state config (instance per namespace)
c. static/global config (single instance; Would contain path to log
file, unix socket e.t.c.)

This decoupling would allow much more easily to maintain relation
between conntrack-states and channels (for example, when multiple
namespaces are using the same channel).

Also, currently CONFIG(X) macro allows to reference only a single ct_conf
instance. This will need to be changed so that each namespace has its own
ct_conf_sync instance. And each channel has its own ct_conf_channel instance.

Also, I am afraid that, for this to make more sense, I would have to extend
conntrackd.conf syntax, For example,introduce following top-level sections:
channel {}, sync {} and global {} respectively.

2. Allow to add, remove and list configuration dynamically without
restarting conntrackd. This would require ability to start conntrackd
with minimal global/static configuration. After that add namespaces and
channel configuration by using Unix Domain socket.

For example, instead of starting conntrackd with following command:
conntrackd -C /etc/conntrackd/conntrackd.conf

One would have to use something like this:
conntrackd --global-config /etc/conntrackd/conntrackd_global.conf #
This config file would just specify Unix socket, log file e.t.c.
and then on-the-fly add channel and namespace configuration with:
conntrackd -U /var/run/conntrackd.ctl --add
/etc/conntrackd/conntrackd_namespace1.conf
conntrackd -U /var/run/conntrackd.ctl --add
/etc/conntrackd/conntrackd_channel1.conf
conntrackd -U /var/run/conntrackd.ctl --add
/etc/conntrackd/conntrackd_namespace2.conf
conntrackd -U /var/run/conntrackd.ctl --add
/etc/conntrackd/conntrackd_channel2.conf

We could glue namespaces together with channels by using some IDs.

Another question is, whether over the Unix domain socket we would prefer to
transfer binary (already parsed) or textual (yet unparsed) configuration?

Also, I would need to figure out if/how to maintain backward compatibility with
already existing commands, when there are multiple namespaces (e.g. dump
internal cache, commit external cache ...).

3. Wire protocol format improvements, so that namespace ID would be encapsulated
into the protocol too. This is required, when same channel is being
used by multiple
namespaces.

4. Similarly as CONFIG(x) was broken down into 3 logical pieces, the
same thing would
need to be done for STATE(x) macros.


Thanks,
Ansis
