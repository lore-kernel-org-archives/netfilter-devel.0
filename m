From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 2.4]: Fix deadlock on NAT helper unload
Date: Sat, 07 Oct 2006 21:44:15 -0700 (PDT)
Message-ID: <20061007.214415.74747306.davem@davemloft.net>
References: <4509C252.6010504@trash.net>
	<20061007095011.GA2557@1wt.eu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: w@1wt.eu
In-Reply-To: <20061007095011.GA2557@1wt.eu>
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

From: Willy Tarreau <w@1wt.eu>
Date: Sat, 7 Oct 2006 11:50:11 +0200

> I missed this patch, and it seems David did not notice it either.
> David, do you have any objection against it ? Otherwise I will
> merge it.

No objection, it's been rotting in my mailbox too, sorry:

Signed-off-by: David S. Miller <davem@davemloft.net>
