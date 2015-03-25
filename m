From: Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH nf-next 2/2] netfilter: x_tables: fix cgroup's NF_INET_LOCAL_IN
 sk lookups
Date: Wed, 25 Mar 2015 22:54:48 +0100
Message-ID: <55132EA8.1060603@zonque.org>
References: <cover.1427209409.git.daniel@iogearbox.net> <20fdc704558880831cbbaa8bba5e4855591cd4ba.1427209409.git.daniel@iogearbox.net> <20150325202659.GA27374@salvia> <551329FA.4030002@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: fw@strlen.de, a.perevalov@samsung.com,
	netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from svenfoo.org ([82.94.215.22]:47391 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbbCYVyv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 17:54:51 -0400
In-Reply-To: <551329FA.4030002@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/25/2015 10:34 PM, Daniel Borkmann wrote:
> On 03/25/2015 09:26 PM, Pablo Neira Ayuso wrote:

>> So this is basically needed when early demux is disabled?
>>
>> This is a rather large rework, I would like to know what scenarios
>> we're not currently catching with the existing code.
> 
> Hm, perhaps Daniel can elaborate better, what I have seen in my
> testing when xt_cgroup fails to match the cgroup on ingress traffic
> is i) early demux sysctl disabled, ii) udp on unconnected sockets
> (which I understand is the majority of udp traffic), iii) tcp and
> udp (any kind) on localhost communications. Daniel's original report
> can be found here [1].

Currently, ingress matching fails if the xt_cgroup module's match
callback is called with skb->sk == NULL, which is the case in the
scenarios described above. Also, according to Cong, this is as well
always the case if the ingress network device is 'lo'.

We want to use xt_cgroup to realize a per-application firewall for both
filtering and accounting. For this, being able to catch every network
packet that is destined for or originated by a task that is assigned to
a certain net_cls CGroup controller is essential. Also, the match has to
be effective regardless of the network interface in use.

In my tests, Daniel's patches work perfectly fine.


Thanks,
Daniel

