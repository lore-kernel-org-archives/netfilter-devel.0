From: "David S. Miller" <davem@davemloft.net>
Subject: Re: Status of owner-socketlookup
Date: Wed, 27 Apr 2005 11:49:26 -0700
Message-ID: <20050427114926.45a91b5e.davem@davemloft.net>
References: <Xine.LNX.4.44.0504270037490.16008-100000@thoron.boston.redhat.com>
	<426F64C8.1070601@trash.net> <426FA44A.2010008@evtek.fi>
	<426FA73E.3090605@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: juha.heljoranta@evtek.fi, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <426FA73E.3090605@trash.net>
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

On Wed, 27 Apr 2005 16:52:46 +0200
Patrick McHardy <kaber@trash.net> wrote:

> for incoming packets we really don't know which process is going to
> receive a packet until it calls recvmsg().

Good point.  It does mean that the best thing you can do is
block reception at recvmsg() time, nothing more.  You can't
drop the packet at recvmsg() time because TCP has ACK'd
the thing already etc.
