From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 2.6.21]: ipt_CLUSTERIP: fix oops in checkentry
 function
Date: Tue, 10 Apr 2007 13:26:58 -0700 (PDT)
Message-ID: <20070410.132658.28396541.davem@davemloft.net>
References: <461B86EC.7020707@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <461B86EC.7020707@trash.net>
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
Date: Tue, 10 Apr 2007 14:45:32 +0200

> Fix crash in CLUSTERIP target. I'll push this one to -stable as well.

Applied, thanks Patrick.
