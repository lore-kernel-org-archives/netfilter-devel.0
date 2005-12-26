From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: [PATCH 1/2] conntrack: fix incomplete copying IPv6 addresses
Date: Mon, 26 Dec 2005 04:06:40 +0100
Message-ID: <43AF5E40.8060306@eurodev.net>
References: <200512250736.jBP7abS5014776@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200512250736.jBP7abS5014776@toshiba.co.jp>
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
> [CONNTRACK] fix incomplete copying IPv6 addresses
> 
> If only addresses of orig(reply) tuple is specified, conntrack automatically
> copy them to reply(orig) tuple. This fix makes conntrack possible to copy
> IPv6 addresses correctly and set address family to invert tuple.

Applied. Thanks.

-- 
Pablo
