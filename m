From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 2/2]: conntrack: kill destroy() in struct nf_conntrack
 for diet
Date: Sat, 24 Mar 2007 18:06:35 +0900 (JST)
Message-ID: <200703240906.l2O96aQe027444@toshiba.co.jp>
References: <200703200607.l2K67Piq025156@toshiba.co.jp>
	<45FF807C.3020801@trash.net> <4603DD25.7070306@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4603DD25.7070306@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Fri, 23 Mar 2007 14:59:01 +0100

> Patrick McHardy wrote:
> > Yasuyuki KOZAKAI wrote:
> > 
> >> #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
> >>-static inline void nf_conntrack_put(struct nf_conntrack *nfct)
> >>-{
> >>-	if (nfct && atomic_dec_and_test(&nfct->use))
> >>-		nfct->destroy(nfct);
> >>-}
> > 
> > 
> > 
> > Also applied. I wonder whether we should keep this inline and
> > just have the final destruction be performed out of line, its
> > called in a few quite performance critical paths.
> 
> 
> I've changed your patch so nf_conntrack_put is still an inline
> function and just the destruction is out-of-line.

Looks fine. Thanks.

-- Yasuyuki Kozakai
