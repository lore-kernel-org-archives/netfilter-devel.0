From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [question] ipt_CLUSTERIP and address length
Date: Thu, 25 Feb 2010 13:38:05 +0100
Message-ID: <4B866F2D.8030806@netfilter.org>
References: <20100225101257.GC2667@psychotron.lab.eng.brq.redhat.com> <4B864F9A.90207@trash.net> <4B866A7F.7070205@netfilter.org> <4B866BC5.7030800@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jiri Pirko <jpirko@redhat.com>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netfilter@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4B866BC5.7030800@trash.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Patrick McHardy wrote:
>>> Jiri Pirko wrote:
>>>> Hi all.
>>>>
>>>> I want to ask if there is any particular reason for ipt_CLUSTERIP to support
>>>> only address length of 6 (ETH_ALEN)? It seems to me reasonable for this to work
>>>> even with another types of network hw with different addr_len.
>>> None that I'm aware of, but the length is also used in the ABI,
>>> so you presently can't supply larger addresses.
>> Not directly related to this but I wanted to discuss this time ago. Now
>> that we have xt_CLUSTER I think that we can deprecate ipt_CLUSTERIP.
> 
> If xt_cluster supports everything ipt_CLUSTERIP does, thats fine
> with me.

Yes, xt_cluster supports gateway and back-end clustering while
ipt_CLUSTERIP only works for back-end setup.

I wanted to have some time to document xt_cluster, I have some scripts
lying here and some unfinished documents. I think that we can deprecated
as soon as I have that doc ready.

>> With regards to this issue, it seems arptables only support EUI-48 (6
>> bytes) for ethernet addresses, so xt_CLUSTER would inherit the same
>> problem but the point would be to fix arptables (not sure if possible
>> now without breaking ABI or adding some versioning like iptables).
> 
> arptables currently supports up to 16 byte long addresses. Increasing
> this is difficult since the addresses are embedded in struct arpt_arp.

Hm, so the problem seems to be user-space then:

# arptables -I OUTPUT -o eth1 --h-length 8 \
> -j mangle --mangle-mac-s 01:00:5e:00:01:01:00:00
arptables v0.0.3.3: only --h-length 6 supported
Try `arptables -h' or 'arptables --help' for more information.

As soon as this is fixed. Are 16 bytes long addresses long enough by now?
