From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] nf_conntrack: Don't try to find clashed expectation
Date: Mon, 04 Dec 2006 11:40:17 +0100
Message-ID: <4573FB11.9050108@trash.net>
References: <200612040038.kB40cOJ2004000@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200612040038.kB40cOJ2004000@toshiba.co.jp>
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
> The original code continues loop to find expectation in list if the master
> conntrack of the found expectation is unconfirmed. But it never success
> in that case, because nf_conntrack_expect_related() never insert
> clashed expectation to the list.
> 
> This stops loop in that case.

Also applied, thanks.
