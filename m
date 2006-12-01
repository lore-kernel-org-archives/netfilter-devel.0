From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: nf_conntrack allocation issue
Date: Fri, 1 Dec 2006 09:38:26 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0612010847390.3907@blackhole.kfki.hu>
References: <456EFC8F.2000507@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <456EFC8F.2000507@trash.net>
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

Hi Patrick,

On Thu, 30 Nov 2006, Patrick McHardy wrote:

> I've added these three patches to fix the allocation problems.
> I don't want to add the new module option introduced by
> Jozsef's patch since the current situation is just ridiculous,

In your patch the part

--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -579,7 +579,8 @@ __nf_conntrack_alloc(const struct nf_con
        /* FIXME: protect helper list per RCU */
        read_lock_bh(&nf_conntrack_lock);
        helper = __nf_ct_helper_find(repl);
-       if (helper)
+       /* NAT might want to assign a helper later */
+       if (helper || features & NF_CT_F_NAT)
                features |= NF_CT_F_HELP;
        read_unlock_bh(&nf_conntrack_lock);
 
means that in the IPv4+NAT case we loose what we wanted to gain by the 
features, i.e. for IPv4 with NAT all conntrack entries will be full sized.

> we need to search for both helpers and expectations twice for
> every new connection, so this needs to be redesigned anyway.

As I see this is the price we pay for the features.

What disturbs me is that by the patch segment above, in spite of the 
features we does not gain anything in memory footprint. And the only 
reason for this is that we execute an internal helper lookup after (D)NAT, 
which can *possibly* change the helper (and which is a nice feature).

In order not to loose practically the features in the IPv4+NAT case I 
added the 'keep_helper' module parameter. Because - I think - the typical 
DNAT setups do not rely on the second helper lookup, the good default 
value were '1', i.e. do not waste time on looking up the helper again 
after DNAT *and* in the new structure keep the features. The backward 
compatibility would dictate that the default value is '0'.

I do not argue for the module parameter. But let us do not throw away the 
features in the case of the most usual configuration in the present days.
 
> Last thing is the helper renaming, any objections to prefix
> all helpers with nf_conntrack_helper_?

Fine, that'll make the code more clear.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
