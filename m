From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [NETFILTER 00/05]: updated nf_nat patch
Date: Sat, 04 Nov 2006 12:30:32 +0900 (JST)
Message-ID: <200611040330.kA43UXle029965@toshiba.co.jp>
References: <20061103164836.15103.46291.sendpatchset@localhost.localdomain>
	<200611031734.kA3HYkG6010739@toshiba.co.jp>
	<Pine.LNX.4.64.0611032146390.16098@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kadlec@blackhole.kfki.hu
In-Reply-To: <Pine.LNX.4.64.0611032146390.16098@blackhole.kfki.hu>
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

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date: Fri, 3 Nov 2006 22:03:30 +0100 (CET)

> > My temporary idea is forcing to allocate area for helper in all
> > conntrack after H.323 helper is loaded.
>
> No, that'd be overkill: we'd be back where we were at before 
> introducing the different sized conntrack entries. Something like
> 
> static struct nf_conn *
> __nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
>                      const struct nf_conntrack_tuple *repl,
>                      const struct nf_conntrack_l3proto *l3proto,
> 		     int helperfn)
> {
> 	....
>         if (helper || helperfn)
>                 features |= NF_CT_F_HELP;
> 	...
> }
> 
> static struct nf_conntrack_tuple_hash *
> init_conntrack(const struct nf_conntrack_tuple *tuple,
>                struct nf_conntrack_l3proto *l3proto,
>                struct nf_conntrack_protocol *protocol,
>                struct sk_buff *skb,
>                unsigned int dataoff)
> {
>         struct nf_conn *conntrack;
>         struct nf_conntrack_tuple repl_tuple;
>         struct nf_conntrack_expect *exp;
> 
>         if (!nf_ct_invert_tuple(&repl_tuple, tuple, l3proto, protocol)) {
>                 DEBUGP("Can't invert tuple.\n");
>                 return NULL;
>         }
> 
>         write_lock_bh(&nf_conntrack_lock);
>         exp = find_expectation(tuple);
> 	write_unlock_bh(&nf_conntrack_lock);
> 
> 	conntrack = __nf_conntrack_alloc(tuple, &repl_tuple, l3proto,
> 					 exp->helperfn != NULL);
> 	...
> }
> 
> where 'helperfn' replaces 'assign helper dinamically' from expectfn might 
> work.

Good. write_lock_bh area would be better to cover the codes after
'if(exp) ...', I think.

The other issue that Patrick's pointed out originally needs other solution.
init_conntrack() cannot figure out whether nf_conntrack_alter_reply() will
allocate helper to it or not in future. Any conntrack has possibility to be
allocated helper by nf_conntrack_alter_reply(). My idea is that
__nf_conntrack_alloc() allocates the space for helper in all IPv4
conntrack, if any helper module which handles IPv4 conntrack is
loaded. That was I want to say, and above my sentence looks wrong, sorry.


-- Yasuyuki Kozakai
