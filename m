From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 02/10] nf_conntrack: Introduces a extension
	infrastructure
Date: Mon, 25 Jun 2007 20:16:31 +0200
Message-ID: <4680067F.20204@trash.net>
References: <200706251721.l5PHLQ8x023174@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200706251721.l5PHLQ8x023174@toshiba.co.jp>
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
> Old space allocator of conntrack had problems about extensibility.
> - It required slab cache per combination of extensions.
> - It expected what extensions would be assigned, but it was impossible
>   to expect that completely, then we allocated bigger memory object than
>   really required.
> - It needed to search helper twice due to lock issue.
> 
> Now basic informations of a connection are stored in 'struct nf_conn'.
> And a storage for extension (helper, NAT) is allocated by kmalloc.
> 
> Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>


Also applied, thanks.
