From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nf_conntrack: Fix module refcount dropping too far
Date: Fri, 07 Apr 2006 14:43:11 +0200
Message-ID: <44365E5F.5000004@trash.net>
References: <200604070859.k378xiNM009770@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200604070859.k378xiNM009770@toshiba.co.jp>
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
> If nf_ct_l3proto_find_get() fails to get the refcount of
> nf_ct_l3proto_generic, nf_ct_l3proto_put() will drop the refcount
> too far. Only nf_ct_l3proto_generic has this problem.
> 
> This fix is missing synchronization with ip_conntrack at the last minutes,
> but it's not critical, I think.

Applies cleanly, thanks.
