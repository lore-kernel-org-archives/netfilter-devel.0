From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2.6 0/5]: NAT fixes
Date: Sun, 28 Nov 2004 22:30:30 -0800
Message-ID: <20041128223030.5cbd3e7c.davem@davemloft.net>
References: <41AA5EFC.1080708@trash.net>
	<20041128194231.0985f426.davem@davemloft.net>
	<41AAB30B.3080708@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41AAB30B.3080708@trash.net>
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

On Mon, 29 Nov 2004 06:26:35 +0100
Patrick McHardy <kaber@trash.net> wrote:

> So we have three options:
> 1. revert the patch that introduced the latest bug
> 2. live with the bug in 2.6.10 and put the patches in 2.6.11
> 3. have me double-check the fifth patch and put it in 2.6.10
> 
> I favour the second option, but if you disagree I'm also fine
> with double-checking the fifth patch and putting it in 2.6.10.

I think the second option works for me too.  I'll merge it into
my tree tomorrow.

Thanks Patrick.
