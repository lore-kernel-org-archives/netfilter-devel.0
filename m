From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] CLASSIFY target
Date: 09 Apr 2003 02:21:47 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1049847707.1308.92.camel@tux.rsn.bth.se>
References: <3E92F2F8.1020707@trash.net>
	 <1049832299.1318.19.camel@tux.rsn.bth.se>  <3E935A9C.9030700@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3E935A9C.9030700@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2003-04-09 at 01:26, Patrick McHardy wrote:

> Google found a discussion about moving "skb->priority = sk->priority" 
> line to
> ip_queue_xmit2 to allow netfilter targets to override SO_PRIORITY value of
> local sockets. A quick check told me this change was never made, so the
> CLASSIFY target is only working correctly in the POST_ROUTING chain, which
> is what i have tested. This doesn't seem to affect usage of the target, 
> worse
> would be if POST_ROUTING didn't work correctly. My suggestion is to
> restrict usage to POST_ROUTING chain, this seems like a natural place for
> QoS classification. What do you think ?

Sounds like a good idea since Bert's suggestion was shot down (I think).
Better not upset the gods by including it in this patch :)

We want to touch as little outside code as possible and if someone
really needs this they can google and maybe find this discussion and
then find the original thread and the patch :)

You'll send an updated patch I hope?

-- 
/Martin
