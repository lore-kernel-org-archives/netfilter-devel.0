From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3/2] Fix compile with NAT but without modules
Date: Sun, 23 Jan 2005 20:15:17 -0800
Message-ID: <20050123201517.56619591.davem@davemloft.net>
References: <1106440732.20995.48.camel@tux.rsn.bth.se>
	<41F4426B.3040204@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, gandalf@wlug.westbo.se
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41F4426B.3040204@trash.net>
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

On Mon, 24 Jan 2005 01:33:47 +0100
Patrick McHardy <kaber@trash.net> wrote:

> I'll apply your patches and push them to Dave tomorrow, bkbkits.com
> is unreachable currently so I can't resync my tree.

To be frank, this is one of several severe fallouts from
Rusty's patches.  I really think they were not ready for
submission when he sent them to me.

It even broke the build if you had modules enabled in any
way.

I'm only mentioning this because it appears that nfsim is
becomming partially a crutch, because I know this is what
Rusty and others use heavily for testing.  Which is fine,
but if your patches break the build in many ways in the
real kernel tree you're relying too heavily on the userland
simulator IMHO.
