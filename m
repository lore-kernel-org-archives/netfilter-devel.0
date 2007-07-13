From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: ICMP packets associated with NAT connections sent out wrong
 interface?
Date: Sat, 14 Jul 2007 00:49:05 +0900 (JST)
Message-ID: <200707131549.l6DFn6ST012445@toshiba.co.jp>
References: <46923976.605@trash.net>
	<200707131425.l6DEPBYv013659@toshiba.co.jp>
	<4697911A.60909@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jr-list-2007@quo.to, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4697911A.60909@trash.net>
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
Date: Fri, 13 Jul 2007 16:50:02 +0200

> Yasuyuki KOZAKAI wrote:
> > [NETFILTER]: nf_conntrack: Don't track locally generated special ICMP error
> 
> 
> Thanks. I had to manually apply it because it clashed with the
> pr_debug changes, please verify that I made no mistake. I'll
> also push your original patch to -stable.

Sorry for inconvenience. I've checked it. Looks fine except of a Hunk.
Thanks.

-- Yasuyuki Kozakai
