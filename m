From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER]: Don't checksum CHECKSUM_UNNECESSARY skbs in TCP
 connection tracking
Date: Tue, 3 May 2005 14:23:03 -0700
Message-ID: <20050503142303.2d8e4fd0.davem@davemloft.net>
References: <4277AC7B.6020600@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4277AC7B.6020600@trash.net>
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

On Tue, 03 May 2005 18:53:15 +0200
Patrick McHardy <kaber@trash.net> wrote:

> TCP connection tracking incorrectly tries to verify the checksum of
> CHECKSUM_UNNECESSARY packets. This causes packets on loopback to
> be tracked as INVALID since we now drop the conntrack reference on
> output and don't skip connection tracking on input anymore.

Applied, thanks.
