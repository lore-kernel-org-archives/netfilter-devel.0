From: Dmitry Mishin <dim@openvz.org>
Subject: Re: [PATCH] iptables 32bit compat layer
Date: Wed, 29 Mar 2006 16:38:01 +0400
Message-ID: <200603291638.02842.dim@openvz.org>
References: <200602201110.39092.dim@openvz.org>
	<200603291536.17794.dim@openvz.org> <442A7E72.2080405@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Arnd Bergmann <arnd@arndb.de>, rusty@rustcorp.com.au,
	netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>, devel@openvz.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <442A7E72.2080405@trash.net>
Content-Disposition: inline
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

On Wednesday 29 March 2006 16:32, Patrick McHardy wrote:
> Dmitry Mishin wrote:
> > On Wednesday 29 March 2006 13:28, Patrick McHardy wrote:
> >>>diff --git a/net/compat.c b/net/compat.c
> >>>index 13177a1..6a7028e 100644
> >>>--- a/net/compat.c
> >>>+++ b/net/compat.c
> >>>@@ -476,8 +476,7 @@ asmlinkage long compat_sys_setsockopt(in
> >>> 	int err;
> >>> 	struct socket *sock;
> >>>
> >>>-	/* SO_SET_REPLACE seems to be the same in all levels */
> >>>-	if (optname == IPT_SO_SET_REPLACE)
> >>>+	if (level == SOL_IPV6 && optname == IPT_SO_SET_REPLACE)
> >>> 		return do_netfilter_replace(fd, level, optname,
> >>> 					    optval, optlen);
> >>
> >>I don't understand the reason for this change. If its not a mistake,
> >>it would make more sense to check for IP6T_SO_SET_REPLACE I guess ..
> >
> > IP6T_SO_SET_REPLACE == IPT_SO_SET_REPLACE == XT_SO_SET_REPLACE.
> > Rename will require respective #include directive rename, so, I just
> > leave this as it is. BTW, I'll make respective patch for IPV6 in the near
> > future and this hunk will be removed at all.
>
> I know, but SOL_IPV6 implies IP6T_* - but please don't bother sending
> a new patch for this :) So the point of the change is to exclude IPv6
> from the compat layer because its not implemented yet?
Exactly. Because do_netfilter_replace still works for some cases, but newer 
replacement isn't ready yet.

-- 
Thanks,
Dmitry.
