From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: [BK PATCH] Fix ip_conntrack_amanda data corruption bug that
	breaks amanda dumps
Date: Fri, 5 Nov 2004 02:04:27 +0100
Message-ID: <20041105010427.GA2770@merlin.emma.line.org>
References: <20041104121522.GA16547@merlin.emma.line.org>
	<418A7B0B.7040803@trash.net>
	<20041104231734.GA30029@merlin.emma.line.org>
	<418AC0F2.7020508@trash.net>
	<20041104160655.1c66b7ef.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-net@vger.kernel.org, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20041104160655.1c66b7ef.davem@davemloft.net>
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

> His patch isn't correct, even making a temporary change to
> a shared SKB is illegal.

So the original ip_conntrack_amanda was already illegal. If only such
nonsense caused heavy kernel logging (let it oops or GPF or whatver),
that's a much quicker way to pinpoint the bug than run amanda with a
special devnull configuration some dozen times.

> Things like tcpdump could see corrupt SKB contents if they look during
> that tiny window when the newline character has been changed to NULL
> by the amanda conntrack module.

Where is the SKB stuff documented?

-- 
Matthias Andree
