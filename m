From: Patrick McHardy <kaber@trash.net>
Subject: Re: Patch: nfqnl_mangle skb_trim
Date: Fri, 29 Sep 2006 15:47:17 +0200
Message-ID: <451D23E5.7080806@trash.net>
References: <a1f5b31e0609270831o719e39f9r677408eeb993fc73@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "James D. Nurmi" <jdnurmi+nfdev@gmail.com>
In-Reply-To: <a1f5b31e0609270831o719e39f9r677408eeb993fc73@mail.gmail.com>
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

James D. Nurmi wrote:
> I've got some code very dependant on nfnetlink_queue, and turned up a
> large number of warns coming from skb_trim.  While it's quite possibly
> my code, having not seen it on older kernels made me a bit suspect.
> 
> Anyhow, based on some googling I turned up this thread:
> http://lkml.org/lkml/2006/8/13/56
> 
> And believe the issue to be related, so attached is a small patch to
> the kernel -- not sure if this is completely correct, but for anyone
> else hitting the WARN_ON(1) in skbuff.h, it might be helpful..

Thanks. Can you please send me Signed-off-by: line so I can apply it?
