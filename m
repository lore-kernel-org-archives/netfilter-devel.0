From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] Fix ip_queue for bridged packets
Date: Mon, 27 Oct 2003 00:04:47 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031027000447.417915d0.davem@redhat.com>
References: <200310251709.13913.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
In-Reply-To: <200310251709.13913.bdschuym@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 25 Oct 2003 17:09:13 +0200
Bart De Schuymer <bdschuym@pandora.be> wrote:

> When ip_queue copies an old skbuff to a new one (because the tailroom is
> too small), it uses skb_copy_expand(). This function doesn't copy the
> Ethernet header, which is not needed for normal IP traffic. Normally, the
> Ethernet header is filled in later before doing dev_queue_xmit.
> When ip_queue does this to a bridged IP packet, it has to copy the Ethernet
> header, because the Ethernet header is already filled in and won't be filled
> in again.
> The patch below makes this happen. It puts the code that actually copies the
> header inside netfilter_bridge.h, so that it can be reused and altered
> without touching other code.
> 
> The patch is already approved by Stephen Hemminger (in private mail).
> Since Harald Welte excels in silence, I'm sending netfilter stuff directly
> to you from now on.

I thought we were taking care of this stuff via other means?

This problem feels like an old one to me, and it's why we added all
the bridge netfilter objects to struct sk_buff, right?  Why doesn't
that take care of this instance of the problem?
