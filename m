From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [BK PATCH] Fix ip_conntrack_amanda data corruption bug that
 breaks amanda dumps
Date: Thu, 4 Nov 2004 16:58:47 -0800
Message-ID: <20041104165847.2f178d81.davem@davemloft.net>
References: <20041104121522.GA16547@merlin.emma.line.org>
	<418A7B0B.7040803@trash.net>
	<20041104231734.GA30029@merlin.emma.line.org>
	<418AC0F2.7020508@trash.net>
	<20041104160655.1c66b7ef.davem@davemloft.net>
	<20041105010427.GA2770@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-net@vger.kernel.org, netfilter-devel@lists.netfilter.org,
	kaber@trash.net, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Matthias Andree <matthias.andree@gmx.de>
In-Reply-To: <20041105010427.GA2770@merlin.emma.line.org>
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

On Fri, 5 Nov 2004 02:04:27 +0100
Matthias Andree <matthias.andree@gmx.de> wrote:

> On Thu, 04 Nov 2004, David S. Miller wrote:
> 
> > His patch isn't correct, even making a temporary change to
> > a shared SKB is illegal.
> 
> So the original ip_conntrack_amanda was already illegal. If only such
> nonsense caused heavy kernel logging (let it oops or GPF or whatver),
> that's a much quicker way to pinpoint the bug than run amanda with a
> special devnull configuration some dozen times.

The original ip_conntrack_amanda was correct before
my skb_header_pointer() changes.  Patrick's patch, which
I'll of course apply, simply reverted those changes back
to the original code which uses the amanda_buffer for
the UDP control stream always.
