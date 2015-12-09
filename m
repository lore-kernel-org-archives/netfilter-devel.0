From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH] Add tcindex to conntrack and add netfilter target/matches
Date: Wed, 09 Dec 2015 10:07:21 +0100
Message-ID: <5667EF49.8060707@iogearbox.net>
References: <1449179951-26327-1-git-send-email-luuk.paulussen@alliedtelesis.co.nz> <1449179951-26327-2-git-send-email-luuk.paulussen@alliedtelesis.co.nz> <5664B698.8040904@alliedtelesis.co.nz> <20151206224522.GA27161@breakpoint.cc> <5664ECCC.1030104@alliedtelesis.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Luuk Paulussen <Luuk.Paulussen@alliedtelesis.co.nz>,
	Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:53066 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbbLIJH2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Dec 2015 04:07:28 -0500
In-Reply-To: <5664ECCC.1030104@alliedtelesis.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12/07/2015 03:19 AM, Luuk Paulussen wrote:
> On 12/07/2015 11:45 AM, Florian Westphal wrote:
>> Luuk Paulussen <Luuk.Paulussen@alliedtelesis.co.nz> wrote:
>>> Hi All,
>>>
>>> I'm still hoping for some feedback on this.  I have some userspace
>>> patches around this as well, (to set/show the tc_index in the
>>> connection, and to add the marking/matching rules in iptables), but I am
>>> holding off on sending them until I know what people think of this
>>> idea/implementation first.
>> I can't say for sure since I don't know enough about tc.
>>
>> However, AFAICS tc_index seems to be something that should be internal
>> to tc and not exposed/changeable via iptables.
> tc_index is a mark that can be set by certain configurable ingress
> schedulers (dsmark, GRED, ingress) for later classification via the
> tcindex classifer.  This just adds an alternative mechanism for setting
> this mark if those schedulers aren't being used.

Fwiw, tc_index can be read/written by cls_bpf (and you can also apply masks
on that field if needed).

> * dsmark sets the tc_index value based on the incoming DSCP value
> * ingress sets the tc_index value based on other rules (e.g. mark set
> via iptables)
> * New code sets tc_index directly based on iptables classification or
> restoring saved value.
