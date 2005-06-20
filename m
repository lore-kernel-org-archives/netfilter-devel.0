From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.12: connection tracking broken?
Date: Mon, 20 Jun 2005 04:45:15 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0506200432100.31737@kaber.coreworks.de>
References: <E1Dk9nK-0001ww-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: bdschuym@pandora.be, netfilter-devel@manty.net,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	ebtables-devel@lists.sourceforge.net, rankincj@yahoo.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
In-Reply-To: <E1Dk9nK-0001ww-00@gondolin.me.apana.org.au>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 20 Jun 2005, Herbert Xu wrote:
> Patrick McHardy <kaber@trash.net> wrote:
>>
>> The bridge-netfilter code defers calling of some NF_IP_* hooks to the
>> bridge layer, when the conntrack reference is already gone, so the entry
>
> Why does it defer them at all? Shouldn't the fact that the device is
> bridged be transparent to the IP layer?

I couldn't figure out the reason, it seems to have something to do
with setting up device pointers for iptables and ebtables. It looks
like the only way to fix this problem without keeping the conntrack
reference while packets are queued at the device is to avoid defering
the NF_IP_* hooks. Bart, can you explain why the hooks are defered
please?

Regards
Patrick
