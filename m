From: "Jeff Chua" <jeff.chua.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: nf_conntrack - still missing one critical patch
Date: Thu, 14 Feb 2008 09:00:29 +0800
Message-ID: <b6a2187b0802131700k3263f4dam30d170208844c9a9@mail.gmail.com>
Reply-To: "Mirror of cups.bugs Newsgroup" <cups-bugs-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Netfilter Development Mailinglist <netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cups-bugs <cups-bugs-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
To: "Jozsef Kadlecsik" <kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org>,
	"Krzysztof Piotr Oledzki" <ole-gcSpNFQc7Gg@public.gmane.org>
Return-path: <cups-bugs-bounces-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <http://lists.easysw.com/mailman/listinfo/cups-bugs>,
	<mailto:cups-bugs-request-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org?subject=unsubscribe>
List-Post: <mailto:cups-bugs-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
List-Help: <mailto:cups-bugs-request-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org?subject=help>
List-Subscribe: <http://lists.easysw.com/mailman/listinfo/cups-bugs>,
	<mailto:cups-bugs-request-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org?subject=subscribe>
Sender: cups-bugs-bounces-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org
Errors-To: cups-bugs-bounces-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

Jozsef, Krzysztof

Have you had a chance to take a look at this missing bit?

Thanks,
Jeff.


On Feb 10, 2008 11:06 PM, Jeff Chua <jeff.chua.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Feb 5, 2008 9:47 PM, Patrick McHardy wrote:
> >> On Feb 5, 2008 4:16 PM, Jozsef Kadlecsik wrote:
> >> Patrick, I suppose you need a patch against the latest git, don't you?
> > Yes, please. I'll take you first patch for -stable though if you
> > send me a Signed-off-by: line.
>
> Please note the lastest git commit is missing one part (which was in
> Jozsef's original patch).
>
>         commit b2155e7f70b3f058efe94c0c459db023b05057bd
>         Author: Jozsef Kadlecsik <kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org>
>         Date:   Thu Feb 7 17:54:56 2008 -0800
>
>             [NETFILTER]: nf_conntrack: TCP conntrack reopening fix
>
>
> I've tested the following missing patch, and it solves the cups slow
> printing problem.
>
>
> Thanks,
> Jeff
>
> --- a/net/netfilter/nf_conntrack_proto_tcp.c.org        2008-02-10 22:45:49 +0800
> +++ a/net/netfilter/nf_conntrack_proto_tcp.c    2008-02-10 22:45:56 +0800
> @@ -945,7 +945,7 @@
>
>         ct->proto.tcp.state = new_state;
>         if (old_state != new_state
> -           && new_state == TCP_CONNTRACK_CLOSE)
>
> +           && new_state == TCP_CONNTRACK_FIN_WAIT)
>                 ct->proto.tcp.seen[dir].flags |= IP_CT_TCP_FLAG_CLOSE_INIT;
>         timeout = ct->proto.tcp.retrans >= nf_ct_tcp_max_retrans
>                   && tcp_timeouts[new_state] > nf_ct_tcp_timeout_max_retrans
>
