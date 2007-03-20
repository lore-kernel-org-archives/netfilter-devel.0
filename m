From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2]: conntrack: kill destroy() in struct nf_conntrack
 for diet
Date: Tue, 20 Mar 2007 07:34:36 +0100
Message-ID: <45FF807C.3020801@trash.net>
References: <200703200607.l2K67Piq025156@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200703200607.l2K67Piq025156@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
>  #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
> -static inline void nf_conntrack_put(struct nf_conntrack *nfct)
> -{
> -	if (nfct && atomic_dec_and_test(&nfct->use))
> -		nfct->destroy(nfct);
> -}


Also applied. I wonder whether we should keep this inline and
just have the final destruction be performed out of line, its
called in a few quite performance critical paths.
