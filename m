From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: TCP window tracking patch status query for further design
 considerations
Date: Wed, 9 Oct 2002 00:32:57 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0210090017160.24530-100000@blackhole.kfki.hu>
References: <3DA2F1E8.8000704@tac.ch>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
In-Reply-To: <3DA2F1E8.8000704@tac.ch>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Tue, 8 Oct 2002, Roberto Nibali wrote:

> Could you explain or point me to some RFC for the following lines in the TCP
> window tracking patch.?
>
> +/* Fixme: what about big packets? */
> +#define MAXACKWINCONST                 66000
> +#define MAXACKWINDOW(sender)           ((sender)->td_maxwin > MAXACKWINCONST ?
> (sender)->td_maxwin : MAXACKWINCONST)

Read Guido's article on which the patch is based:
http://www.iane.nl/users/guido/papers/tcp_filtering.ps.gz

The constant is a little bit bigger than the maximal possible window size
without window scaling. The macro tries to take window scaling into
account.

> Shouldn't it be (or what is the point of having MAXACKWINCONST):
>
> +#define MAXACKWINDOW(sender)           ((sender)->td_maxwin > MAXACKWINCONST ?
>   MAXACKWINCONST : (sender)->td_maxwin)

No, it'd make the possible ACK window smaller in the case of window
scaling.

> Why do you do the following thing? Isn't it up to the ruleset to take care of
> this? What if I would like to have those flags accepted :)?
[...]

Those packets are either corrupted or invalid ones sent deliberately
and would (wrongly) be reported as out of window ones.

Most of the out of window log entries created by the earlier patch
releases was generated because the code was not protected against such
packets.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
