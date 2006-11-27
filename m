From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2]: conntrack: add '_get' to {ip,
	nf}_conntrack_expect_find
Date: Mon, 27 Nov 2006 18:40:10 +0100
Message-ID: <456B22FA.2060308@trash.net>
References: <200611232315.kANNFdTi014003@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200611232315.kANNFdTi014003@toshiba.co.jp>
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
> # Sorry, I forgot netfilter-devel, so resend.
> 
> We usually uses 'xxx_find_get' for function which increments
> reference count.

Applied on top of Martin's changes.

Unfortunately I have to wait with pushing Martin's patches
now since they conflict with your first patch, which should
go in 2.6.19.
