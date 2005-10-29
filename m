From: Grzegorz Janoszka <Grzegorz.Janoszka@pro.onet.pl>
Subject: Re: IPMARK nfcache
Date: Sat, 29 Oct 2005 18:53:11 +0200 (CEST)
Message-ID: <Pine.GSO.4.63.0510291849040.28447@galaxy.agh.edu.pl>
References: <20051028221728.GC10248@samad.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Alexander Samad <alex@samad.com.au>
In-Reply-To: <20051028221728.GC10248@samad.com.au>
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

On Sat, 29 Oct 2005, Alexander Samad wrote:

> Recently went to path IPMARK (Patchlet from patch o matic) to a 2.6.14
> source tree and I have noticed this compilation error
> net/ipv4/netfilter/ipt_IPMARK.c: In function 'target':
> net/ipv4/netfilter/ipt_IPMARK.c:36: error: 'struct sk_buff' has no
> member named 'nfcache'
> net/ipv4/netfilter/ipt_IPMARK.c:36: error: 'NFC_ALTERED' undeclared
> (first use in this function)
> on investigation the nfcache field from sk_buff has been removed, having
> a look on the net as to why
> I was wondering what mechanism is need to replace the 'ncfcache |
> NFC_ALTERED' statement

My IPMARK was based on original MARK target. You can look what has changed 
in libipt_MARK.c and correct it.

I don't know if I have to submit a new patch or it will be corrected by 
netfilter developers?

-- 
Grzegorz Janoszka
