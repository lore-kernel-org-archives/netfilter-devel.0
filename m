From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Last vestiges of NFC
Date: Sun, 02 Sep 2007 14:01:59 +0200
Message-ID: <46DAA637.4070606@trash.net>
References: <46D06522.2090509@hotpop.com>	<46D06FF8.5090004@hotpop.com>	<46D5A5B9.2030107@trash.net>	<46D6DEAF.9010009@hotpop.com>	<Pine.LNX.4.64.0708302040350.24730@fbirervta.pbzchgretzou.qr>	<46D824EA.1060406@hotpop.com>	<46D83F90.5060600@trash.net>
	<46D9BE2A.4070901@hotpop.com> <46D9C40D.6030001@hotpop.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter-devel@lists.netfilter.org
To: Peter.Riley@hotpop.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46D9C40D.6030001@hotpop.com>
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

Peter Riley wrote:
> Peter Riley wrote:
>> p-o-m-ng probably needs patching now too.  I'll take a look...
> 
> A quick check found four occurrences.
> These two are in old kernel code.
> 
> patchlets/TARPIT/linux/net/ipv4/netfilter/ipt_TARPIT.c
> -	nskb->nfcache = 0;
> 
> patchlets/IPV4OPTSSTRIP/linux/net/ipv4/netfilter/ipt_IPV4OPTSSTRIP.c
> -	skb->nfcache |= NFC_ALTERED;


That seems to be 2.4 code.

> But these two are in match extensions.  See patch.
> 
> patchlets/ipv4options/iptables/extensions/libipt_ipv4options.c
> patchlets/u32/iptables/extensions/libipt_u32.c


Also applied, thanks.
