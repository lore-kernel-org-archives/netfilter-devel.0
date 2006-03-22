From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [00/10]: Netfilter Update
Date: Wed, 22 Mar 2006 13:59:06 -0800 (PST)
Message-ID: <20060322.135906.60572272.davem@davemloft.net>
References: <20060322184740.5655.7960.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20060322184740.5655.7960.sendpatchset@localhost.localdomain>
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
Date: Wed, 22 Mar 2006 19:47:40 +0100 (MET)

> this is the second try with my netfilter patches for 2.6.17. It
> includes the fix for the ip6tables breakage and the H.323 linking
> error - compile tested in serveral combinations. Please apply.

All applied, thanks a lot Patrick.

>       [NETFILTER]: Fix undefined references to get_h225_addr

I never in a million years would have thought that exporting
a symbol to modules would work if the symbol was declared
static :-)  But come to think of it, I see nothing that prevents
this.

I wonder if this could be prevented somehow using so me construct
in the module symbol export macros?
