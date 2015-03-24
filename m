From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next 0/2] xt_cgroups fix
Date: Tue, 24 Mar 2015 16:58:06 +0100
Message-ID: <5511898E.5000007@iogearbox.net>
References: <cover.1427209409.git.daniel@iogearbox.net> <20150324154216.GD1685@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, daniel@zonque.org, a.perevalov@samsung.com,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:48091 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbbCXP6N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2015 11:58:13 -0400
In-Reply-To: <20150324154216.GD1685@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/24/2015 04:42 PM, Florian Westphal wrote:
> Daniel Borkmann <daniel@iogearbox.net> wrote:
>> here's a possible fix for xt_cgroups that was previously reported
>> by Daniel Mack.
>>
>> The first patch refactors common helpers, which is later on being
>> used by the actual fix. Please see individual patches for more
>> details.
>>
>> I have based the changes on nf-next as they're rather big, they
>> are, however, on top of Eric's a94070000388 ("netfilter: xt_socket:
>> prepare for TCP_NEW_SYN_RECV support") from net-next to avoid ugly
>> merge conflicts in xt_socket.
>>
>> If you nevertheless think it's more suited for nf, or I should
>> ignore the above conflicting commit, I'd be happy to rebase.
>
> My main problem with these patches is that we're now paving the way
> for skb->sk testing in input, i.e. doing protocol demuxing steps
> in iptables modules.

Well, we're doing this in xt_socket already, here it's just fixing
a real issue in xt_cgroup. The only alternative I currently see
would be to revert Alexey's commit, but that would limit the scope
of possibilities for xt_cgroup quite a lot. :(

> E.g. why not accept similar patch for xt_owner?
> What about sctp (or any other protocol) support?

Right, I see your concern, but at the same time I think that i.e.
SCTP has much more severe problems, i) being the horrible state of
the stack implementation itself ;), ii) being the lack of more
important features in iptables (i.e. NAT on multi-homing). Anyway,
taken that aside, you could restrict that support, as we currently
do only for available early demuxes, but given that activity on
SCTP I truly doubt that's coming any time soon.

> I don't see anything wrong with the implementation per se but I'm afraid
> we're starting down a slippery slope here.
