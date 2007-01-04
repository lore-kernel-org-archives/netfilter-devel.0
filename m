From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 05/05]: ebtables: don't compute gap before checking
 struct type
Date: Thu, 04 Jan 2007 12:18:00 -0800 (PST)
Message-ID: <20070104.121800.40144440.davem@davemloft.net>
References: <20070104183820.18369.3658.sendpatchset@localhost.localdomain>
	<20070104183827.18369.42643.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20070104183827.18369.42643.sendpatchset@localhost.localdomain>
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
Date: Thu,  4 Jan 2007 19:38:27 +0100 (MET)

> [NETFILTER]: ebtables: don't compute gap before checking struct type
> 
> We cannot compute the gap until we know we have a 'struct ebt_entry' and
> not 'struct ebt_entries'.  Failure to check can cause crash.
> 
> Tested-by: Santiago Garcia Mantinan <manty@manty.net>
> Acked-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Chuck Ebbert <76306.1226@compuserve.com>
> Signed-off-by: Andrew Morton <akpm@osdl.org>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Also applied, thanks a lot.
