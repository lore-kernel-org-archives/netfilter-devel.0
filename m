From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [RFC,PATCH] introduce new API for libnfnetlink
Date: Wed, 21 Jun 2006 17:24:47 +0100
Message-ID: <449972CF.6060402@ufomechanic.net>
References: <4495E142.5000209@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4495E142.5000209@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Hi!
> 
> I have been spending some time on libnfnetlink these days based on a
> previous patch that I sent some time ago [1]. Since the amount of
> changes would result in API breakages, that is something that I consider
> that we don't want, I decided to start some kind of version 2 of
> libnfnetlink, the major changes from the current version is:
> 
> - Uniform error handling via errno
> - Use of new netlink ADD_MEMBERSHIP socket option to join multicast groups
> - A new approach for challenge functions listen/talk, now they use the
> callbacks registered via register_callback()
> - Single loop processing: nfnetlink_process()
> - Iterators: more control for the programmer in the nfnetlink data
> processing
> - addattr* simplification
> - Documentation available
> 
> The patch is available at:
> 
> http://people.netfilter.org/pablo/libnfnetlink-newapi.patch

Thanks for this Pablo.

As long as there is still a way to exit the message reading loop at the
end of the current packet (without discarding any messages), then it
will suit me.

I'm using the old conntrack API by receiving events and periodic dumps
of all conntracks over the same netlink. At certain times a signal goes
off which sets a flag to exit the read loop after the current netlink
packet, then a conntrack dump is requested and the readloop is re-entered.

I suppose this will still be possible?

Sam
