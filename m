From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Sun, 3 Apr 2005 16:53:20 -0700
Message-ID: <20050403235320.GB28850@linuxace.com>
References: <20050402202438.GA2968@linuxace.com> <4250435E.1090309@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4250435E.1090309@trash.net>
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

On Sun, Apr 03, 2005 at 09:26:22PM +0200, Patrick McHardy wrote:
> Great work Phil. One question though: You want to store the pre-adjusted
> sequence number. What if the packet is a retransmission and
> offset_before has been applied? If I understand correctly, depending
> on the delta between offset_after and offset_before, this might cause
> the before(...) test to give a false positive and screw up the state.
> In case I'm wrong, could you a patch containing only the necessary
> changes? I think the final fix for this problem should go in -stable,
> ideally it would only be a single line "seq -= this_way->offset_after".

I think you are correct, retransmission would falsely trigger the before.
Testing a new patch...will likely submit tomorrow.

Phil
