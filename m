From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next 2/2] netfilter: x_tables: fix cgroup's NF_INET_LOCAL_IN
 sk lookups
Date: Wed, 25 Mar 2015 22:34:50 +0100
Message-ID: <551329FA.4030002@iogearbox.net>
References: <cover.1427209409.git.daniel@iogearbox.net> <20fdc704558880831cbbaa8bba5e4855591cd4ba.1427209409.git.daniel@iogearbox.net> <20150325202659.GA27374@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: daniel@zonque.org, fw@strlen.de, a.perevalov@samsung.com,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:54366 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbbCYVe4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 17:34:56 -0400
In-Reply-To: <20150325202659.GA27374@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/25/2015 09:26 PM, Pablo Neira Ayuso wrote:
> On Tue, Mar 24, 2015 at 04:30:29PM +0100, Daniel Borkmann wrote:
>> While originally only being intended for outgoing traffic, commit
>> a00e76349f35 ("netfilter: x_tables: allow to use cgroup match for
>> LOCAL_IN nf hooks") enabled xt_cgroups for the NF_INET_LOCAL_IN hook
>> as well, in order to allow for nfacct accounting.
>>
>> This basically was under the assumption that socket early demux will
>> resolve it. It's correct that demux happens after PRE_ROUTING, but
>> before LOCAL_IN.
>>
>> However, that as-is only partially works, i.e. it works for the case
>> of established TCP and connected UDP sockets when early demux is
>> enabled, but not for various other ingress scenarios e.g. unconnected
>> UDP, request sockets, etc.
>>
>> Instead of reverting commit a00e76349f35, I think it's worth to fix
>> it up as there are applications requiring xt_cgroup to match on
>> ingress and egress side. In order to do so, we need to perform a
>> full lookup on skb->sk (ingress) miss, similarly as being done in
>> xt_socket.
>>
>> Therefore, we need to make use of shared helpers xt_sk_lookup() and
>> xt_sk_lookup6(). Thanks to Daniel for the report and also additional
>> testing.
>
> So this is basically needed when early demux is disabled?
>
> This is a rather large rework, I would like to know what scenarios
> we're not currently catching with the existing code.

Hm, perhaps Daniel can elaborate better, what I have seen in my
testing when xt_cgroup fails to match the cgroup on ingress traffic
is i) early demux sysctl disabled, ii) udp on unconnected sockets
(which I understand is the majority of udp traffic), iii) tcp and
udp (any kind) on localhost communications. Daniel's original report
can be found here [1].

Thanks,
Daniel

   [1] http://thread.gmane.org/gmane.linux.network/355527
