From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2.6]: Prevent NAT from seeing fragments
Date: Wed, 23 Feb 2005 20:10:52 -0800
Message-ID: <20050223201052.6a472c00.davem@davemloft.net>
References: <42153590.8010704@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42153590.8010704@trash.net>
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

On Fri, 18 Feb 2005 01:23:44 +0100
Patrick McHardy <kaber@trash.net> wrote:

> This patch fixes another fragment handling problem, on loopback NAT might
> get to see fragments because conntrack skips defragmentation for already
> seen traffic. It just meant as a temporary solution for 2.6.11, in 2.6.12
> we would prefer to skip refragmentation for loopback if it doesn't cause
> problems.

Applied for 2.6.11, thanks Patrick.
