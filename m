From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: [BK PATCH] Fix ip_conntrack_amanda data corruption bug that
	breaks amanda dumps
Date: Fri, 5 Nov 2004 12:30:33 +0100
Message-ID: <20041105113033.GA10276@merlin.emma.line.org>
References: <20041104121522.GA16547@merlin.emma.line.org>
	<418A7B0B.7040803@trash.net>
	<20041104231734.GA30029@merlin.emma.line.org>
	<418AC0F2.7020508@trash.net>
	<20041104160655.1c66b7ef.davem@davemloft.net>
	<20041105010427.GA2770@merlin.emma.line.org>
	<20041104165847.2f178d81.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-net@vger.kernel.org, netfilter-devel@lists.netfilter.org,
	kaber@trash.net, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20041104165847.2f178d81.davem@davemloft.net>
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

On Thu, 04 Nov 2004, David S. Miller wrote:

> The original ip_conntrack_amanda was correct before
> my skb_header_pointer() changes.  Patrick's patch, which
> I'll of course apply, simply reverted those changes back
> to the original code which uses the amanda_buffer for
> the UDP control stream always.

OK, thanks to both of you for handling this.

One question remains though, where is the SKB stuff documented?  "make
htmldocs" didn't elucidate me, neither did "grep -r skb_header_pointer
Documentation"

-- 
Matthias Andree
