From: Ansis Atteka <ansisatteka@gmail.com>
Subject: Re: [PATCHv3] conntrackd: make conntrackd namespace aware
Date: Fri, 12 Oct 2012 19:02:01 -0700
Message-ID: <CAMQa7Bg9Wf1emNYnS9J4375d4Xhrs7NLRuj2ZBJD==hbXGBMTA@mail.gmail.com>
References: <1349315351-6689-1-git-send-email-aatteka@nicira.com>
	<20121010223556.GA6160@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ansis Atteka <aatteka@nicira.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40580 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab2JMCCE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Oct 2012 22:02:04 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so2430349lbo.19
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Oct 2012 19:02:02 -0700 (PDT)
In-Reply-To: <20121010223556.GA6160@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10 October 2012 15:35, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Ansis,
>
> On Wed, Oct 03, 2012 at 06:49:10PM -0700, Ansis Atteka wrote:
>> This patch allows conntrackd to open CT Netlink sockets into a given
>> network namespace. Channel sockets (e.g. UDP) would still be opened into
>> the same namespace where conntrackd was started.
>>
>> The only binary this patch affects is conntrackd. All other binaries (e.g.
>> conntrack, nfct) would still operate in the same namespace where they were
>> started.
>>
>> To make use of this patch:
>> 1. create a network namespace: "ip netns add the_ns"
>> 2. add "NetlinkNamespace /var/run/netns/the_ns" line to the conntrackd.conf
>> file inside General {...} section.
>
> I want to apply this, but user-space helpers got broken with this:
>
> [Thu Oct 11 00:31:13 2012] (pid=12400) [ERROR] could not switch to namespace: Invalid argument
>
> You can use conntrack-tools/doc/helper/conntrackd.conf as example.
>
> You also need to use a Linux kernel 3.6 to test this user-space helper
> feature, see: http://conntrack-tools.netfilter.org/manual.html#helpers

After a quick try to configure user-space helpers, I am seeing following error:

root@aatteka-virtual-machine:~# uname -r
3.6.0-030600-generic
root@aatteka-virtual-machine:~# nfct helper add rpc inet tcp
nfct v1.2.2: error: Invalid argument
root@aatteka-virtual-machine:~# nfct helper list
nfct v1.2.2: error: Invalid argument

gdb tells me that this is response on NFNL_MSG_CTHELPER_[GET|NEW]
messages. Am I missing something when registering user-space helpers?

Thanks,
Ansis

> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
