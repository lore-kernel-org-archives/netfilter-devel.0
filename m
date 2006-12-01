From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack allocation issue
Date: Fri, 01 Dec 2006 14:11:55 +0100
Message-ID: <45702A1B.20608@trash.net>
References: <456EFC8F.2000507@trash.net>
	<Pine.LNX.4.64.0612010847390.3907@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.64.0612010847390.3907@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:
> Hi Patrick,
> 
> In your patch the part
> 
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -579,7 +579,8 @@ __nf_conntrack_alloc(const struct nf_con
>         /* FIXME: protect helper list per RCU */
>         read_lock_bh(&nf_conntrack_lock);
>         helper = __nf_ct_helper_find(repl);
> -       if (helper)
> +       /* NAT might want to assign a helper later */
> +       if (helper || features & NF_CT_F_NAT)
>                 features |= NF_CT_F_HELP;
>         read_unlock_bh(&nf_conntrack_lock);
>  
> means that in the IPv4+NAT case we loose what we wanted to gain by the 
> features, i.e. for IPv4 with NAT all conntrack entries will be full sized.

Yes - actually that part is similar to your patch besides the
keep_helper option.

>>we need to search for both helpers and expectations twice for
>>every new connection, so this needs to be redesigned anyway.
> 
> 
> As I see this is the price we pay for the features.

I see it as a sign of serious misfit of the allocation scheme.
The helper and expectation lookups both really suck performance
wise already, doing them twice is just horrible.

> What disturbs me is that by the patch segment above, in spite of the 
> features we does not gain anything in memory footprint. And the only 
> reason for this is that we execute an internal helper lookup after (D)NAT, 
> which can *possibly* change the helper (and which is a nice feature).
> 
> In order not to loose practically the features in the IPv4+NAT case I 
> added the 'keep_helper' module parameter. Because - I think - the typical 
> DNAT setups do not rely on the second helper lookup, the good default 
> value were '1', i.e. do not waste time on looking up the helper again 
> after DNAT *and* in the new structure keep the features. The backward 
> compatibility would dictate that the default value is '0'.
> 
> I do not argue for the module parameter. But let us do not throw away the 
> features in the case of the most usual configuration in the present days.

The reason why I didn't want to add it is that IMO the allocation
scheme needs to be redesigned anyway, so when we do it we might end
up with a module parameter we had for two months and need to carry
around forever. We can still add it any time we want, but for now
my priority is to get it right (i.e. working properly, not
optimized) without doing anything we might regret later. Module
parameters for rather obscure internal stuff tend not to get used
anyway, so most users don't loose anything.
