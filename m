From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xt_sctp - add SCTP header size to IP header offset
Date: Mon, 19 Jun 2006 16:53:30 +0200
Message-ID: <4496BA6A.3040308@trash.net>
References: <200606081754.09073.jorge.matias@motorola.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jorge Matias Martin <jorge.matias@motorola.com>
In-Reply-To: <200606081754.09073.jorge.matias@motorola.com>
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

Jorge Matias Martin wrote:
> Hi, all.
> 
> xt_sctp module is not working on 2.6.16 when --chunk-types option is used. I 
> have test this running sctp_darn and the following iptables options:
> 
> -A INPUT -p sctp --chunk-types any INIT -j DROP
> 
> And this is the kernel log output:
> 
> spt: 32822    dpt: 10105
> Chunk num: 1  offset: 20      type: 128       length: 10105   flags: 36
> skb->len: 92  offset: 10128
> spt: 10105    dpt: 32822
> Chunk num: 1  offset: 20      type: 39        length: 32822   flags: 79
> skb->len: 284 offset: 32844
> spt: 32822    dpt: 10105
> Chunk num: 1  offset: 20      type: 128       length: 10105   flags: 36
> ...
> 
> 
> Note that length is actually the local port, and offset must be 32 (20 IPv4 
> header + 12 SCTP header).
> 
> FYI, it works properly when --chunk-types is not used.

Looks good too me. Please add a Signed-off-by: line so I can
apply it. Thanks.
