From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER]: Ignore PSH on SYN/ACK in TCP connection tracking
Date: Sun, 24 Apr 2005 18:43:09 -0700
Message-ID: <20050424184309.0cd479ea.davem@davemloft.net>
References: <426C127B.9030108@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <426C127B.9030108@trash.net>
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

On Sun, 24 Apr 2005 23:41:15 +0200
Patrick McHardy <kaber@trash.net> wrote:

> This patch fixes a problem with TCP connection tracking and
> some devices that respond with SYN/ACK/PSH to a SYN packet.
> TCP connection tracking considers these packets to be invalid
> and the connection never reaches an estabished state. Ignore
> PSH on SYN/ACKs.

Applied, thanks Patrick.
