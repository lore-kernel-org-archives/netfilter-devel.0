From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] MASQUERADE handling of device events
Date: Mon, 8 Nov 2004 08:15:11 -0800
Message-ID: <20041108161511.GA6754@linuxace.com>
References: <20041107181825.GA3522@linuxace.com> <418F9952.5030004@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-net@vger.kernel.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <418F9952.5030004@trash.net>
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

On Mon, Nov 08, 2004 at 05:05:38PM +0100, Patrick McHardy wrote:
> But without the ifindex comparison, a situation like this can happen:
> 
> ppp0 goes down
> ppp1 goes down
> ppp0 comes up again, same IP as before
> ppp1 connections get killed
> ppp1 comes up again
> 
> So we should keep this.

But ifindex is meaningless on ppp interfaces - it is incremented on each
cycle.  So there is no way to say that the original ppp1 is the same
interface as the new ppp1.

ifindex just cannot be used reliably.

Phil
