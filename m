From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [question] ipt_CLUSTERIP and address length
Date: Thu, 25 Feb 2010 14:03:13 +0100
Message-ID: <4B867511.7050204@netfilter.org>
References: <20100225101257.GC2667@psychotron.lab.eng.brq.redhat.com> <4B864F9A.90207@trash.net> <4B866A7F.7070205@netfilter.org> <alpine.LSU.2.01.1002251347580.11377@obet.zrqbmnf.qr> <20100225125631.GF2667@psychotron.lab.eng.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Jiri Pirko <jpirko@redhat.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20100225125631.GF2667@psychotron.lab.eng.brq.redhat.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jiri Pirko wrote:
> Thu, Feb 25, 2010 at 01:54:50PM CET, jengelh@medozas.de wrote:
>> On Thursday 2010-02-25 13:18, Pablo Neira Ayuso wrote:
>>>>> I want to ask if there is any particular reason for ipt_CLUSTERIP to support
>>>>> only address length of 6 (ETH_ALEN)? It seems to me reasonable for this to work
>>>>> even with another types of network hw with different addr_len.
>>>> None that I'm aware of, but the length is also used in the ABI,
>>>> so you presently can't supply larger addresses.
>>> Not directly related to this but I wanted to discuss this time ago. Now
>>> that we have xt_CLUSTER I think that we can deprecate ipt_CLUSTERIP.
>> xt_CLUSTER - where in the tree would that be?
> 
> I was trying to find it too. I guess it stands out of it (at least net-next).

sorry, it's xt_cluster, no capitalization.

pablo@decadence:~/devel/scm/git/nf-2.6$ ls net/netfilter/xt_cluster.c

It's there since quite some time.
