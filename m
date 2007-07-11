From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/3] conntrack stat fix and introducing nf_ct_get_tuplepr
Date: Wed, 11 Jul 2007 20:10:10 +0200
Message-ID: <46951D02.3060306@trash.net>
References: <200707111506.l6BF68vi020693@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: jengelh@computergmbh.de, netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707111506.l6BF68vi020693@toshiba.co.jp>
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
> This patchset is for introducing nf_ct_get_tuplepr which doesn't require
> offset to transport protocol header, l3proto module, and l4proto mdoule.


All applied, thanks Yasuyuki.
