From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] modification in current protocol helper API to handle
 error/unclean packets
Date: Mon, 21 Jun 2004 10:11:57 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406211002370.31871-100000@blackhole.kfki.hu>
References: <1087759076.9146.32.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira <pablo@eurodev.net>,
	Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1087759076.9146.32.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Martin,

On Sun, 20 Jun 2004, Martin Josefsson wrote:

> > - Jozsef, I resolve to use your inverse return value but I must confess
> > that I'm still thinking about another way to do that with no sucess,
>
> What's the deal with these inverse return values in tcp-window-tracking
> and now conntrack_error-api?
>
> Sometimes we return NF_ACCEPT and sometimes we return -NF_ACCEPT which
> have two completely diffrent meanings. That's really really ugly.

Yes, it's ugly. That was introduced as a (quick) hack to express what you
describe:

> As I've understod it we have two cases:
> 1. We want to return NF_* all the way back to the netfilter core.
> 2. We want conntrack to continue processing the packet.
>
> And we need a way to distinguish these returnvalues.
>
> My suggestion is that when we want NF_* we return NF_* and if we want
> conntrack to continue we return CONNTRACK_CONT which is defined as -1
> All NF_* macros are >= 0
>
> Instead of checking for a negative returnvalue as we do today we check
> != CONNTRACK_CONT and then return the value previously returned to us.
>
> In my oppinion that would greatly improve the readability of the code.
> The mixing of negative and positive values using the same macro
> confuses me sometimes to say the least. I bet I'm not the only one that
> sometimes has to look twice at the return value.
>
> Have I missed something?

No, nothing at all.

> If not and noone objects I'll fix it up in cvs unless someone beats me
> to it.

That'd be great, Martin!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
