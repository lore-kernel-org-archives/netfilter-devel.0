From: "David S. Miller" <davem@davemloft.net>
Subject: Re: Status of owner-socketlookup
Date: Wed, 27 Apr 2005 11:47:22 -0700
Message-ID: <20050427114722.14ddce33.davem@davemloft.net>
References: <Xine.LNX.4.44.0504270958400.17685-100000@thoron.boston.redhat.com>
	<426F9C00.9000804@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <426F9C00.9000804@trash.net>
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

On Wed, 27 Apr 2005 16:04:48 +0200
Patrick McHardy <kaber@trash.net> wrote:

> James Morris wrote:
> > Also, I wonder, if we're doing the socket lookup early (in Netfilter), 
> > perhaps there's some way of caching this so we don't have to do it again 
> > later.
> 
> With NF_SK_HOOK(), filtering would happen in socket context, so
> there is no need to cache it. Otherwise it makes sense I guess.

The TCP socket can be reset between when netfilter looks up
the socket on input and when TCP input processing does the
same.

You aren't locking the socket in this new netfilter input
socket code, so nothing prevents incoming packets from
being delivered to that socket on another cpu and thus
causing the aforementioned resets.

This is why such caching would be illegal.
