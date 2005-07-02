From: Venkata Narayana <mesg2nari@yahoo.com>
Subject: Re: REDIRECT changes DST address of the packet
Date: Fri, 1 Jul 2005 21:15:04 -0700 (PDT)
Message-ID: <20050702041504.69557.qmail@web60814.mail.yahoo.com>
References: <2005530121124577@mail.routehat.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Peter Surda <shurdeek@routehat.org>, netfilter-devel@lists.netfilter.org
In-Reply-To: <2005530121124577@mail.routehat.org>
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

Thanks Peter, Krzysztof and All,

I am able to get the original Destination address and
able to solve the problem.
Thanks once again.
Nari.

--- Peter Surda <shurdeek@routehat.org> wrote:

> On Thu, 30 Jun 2005 10:08:55 +0200 (CEST) Krzysztof
> Oledzki <olenf@ans.pl>
> wrote:
> 
> >> If I lose original DST address, how can I persist
> >> that value in that packet.
> >Please use getsockopt() with SO_ORIGINAL_DST.
> Hehe you were faster than me :-).
> 
> Nari, if you don't understand how to do this, check
> out the source of some
> transparent proxies (squid, p3scan) for examples (as
> Krzysztof said, grep for
> SO_ORIGINAL_DST). I think it's straightforward, I
> even managed to reproduce this
> in perl without using any C.
> 
> >Best regards,
> > 				Krzysztof Olędzki
> Yours sincerely,
> Peter
> 
> 



		
____________________________________________________ 
Yahoo! Sports 
Rekindle the Rivalries. Sign up for Fantasy Football 
http://football.fantasysports.yahoo.com
