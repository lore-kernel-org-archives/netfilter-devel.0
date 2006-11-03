From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [NETFILTER 00/05]: updated nf_nat patch
Date: Fri, 3 Nov 2006 22:03:30 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0611032146390.16098@blackhole.kfki.hu>
References: <20061103164836.15103.46291.sendpatchset@localhost.localdomain>
	<200611031734.kA3HYkG6010739@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200611031734.kA3HYkG6010739@toshiba.co.jp>
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

Hi Yasuyuki,

On Sat, 4 Nov 2006, Yasuyuki KOZAKAI wrote:

> > I've also reviewed the patch a bit, the main problem I found so
> > far is the nf_conntrack allocation scheme, which requires all
> > features to be known at creation time, so it doesn't allow
> > nf_conntrack_alter_reply to assign a helper to a connection
> > that previously didn't have one (same problem for helpers
> > like H.323 which manually assign helpers in their expectfns).
> 
> It might be the time to add something like Rusty's ct_extend.
> 
> My temporary idea is forcing to allocate area for helper in all
> conntrack after H.323 helper is loaded.

No, that'd be overkill: we'd be back where we were at before 
introducing the different sized conntrack entries. Something like

static struct nf_conn *
__nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
                     const struct nf_conntrack_tuple *repl,
                     const struct nf_conntrack_l3proto *l3proto,
		     int helperfn)
{
	....
        if (helper || helperfn)
                features |= NF_CT_F_HELP;
	...
}

static struct nf_conntrack_tuple_hash *
init_conntrack(const struct nf_conntrack_tuple *tuple,
               struct nf_conntrack_l3proto *l3proto,
               struct nf_conntrack_protocol *protocol,
               struct sk_buff *skb,
               unsigned int dataoff)
{
        struct nf_conn *conntrack;
        struct nf_conntrack_tuple repl_tuple;
        struct nf_conntrack_expect *exp;

        if (!nf_ct_invert_tuple(&repl_tuple, tuple, l3proto, protocol)) {
                DEBUGP("Can't invert tuple.\n");
                return NULL;
        }

        write_lock_bh(&nf_conntrack_lock);
        exp = find_expectation(tuple);
	write_unlock_bh(&nf_conntrack_lock);

	conntrack = __nf_conntrack_alloc(tuple, &repl_tuple, l3proto,
					 exp->helperfn != NULL);
	...
}

where 'helperfn' replaces 'assign helper dinamically' from expectfn might 
work.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
