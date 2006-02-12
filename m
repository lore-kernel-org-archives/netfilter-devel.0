From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: [RFC] [NETFILTER] nf_conntrack: more efficient helper lookup
Date: Sun, 12 Feb 2006 22:25:58 +0100
Message-ID: <43EFA7E6.7040909@eurodev.net>
References: <20060212181648.GH4601@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20060212181648.GH4601@sunbeam.de.gnumonks.org>
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

Hi Harald,

Harald Welte wrote:
> As Patrick and I discussed about two weeks ago, the linear iteration
> over the list of helpers with a full tuple compare per helper is
> overkill.
> 
> Please review this suggested patch and comment, thanks.
> 
> Cheers,
> 	Harald
> 
> 
> [NETFILTER] nf_conntrack: more efficient helper lookup
> 
> Instead of iterating over a linear list of helpers, we now keep a hash
> table of them.  Also, we restrict helper match lookup to (l3proto, l4proto,
> dstport) instead of a full-blown tuple/mask lookup.
> 
> Signed-off-by: Harald Welte <laforge@netfilter.org>
> 
> ---
> commit 06d95115655ba6df96d8ad7c92a3d5e91eee39f7
> tree 21a21e59e9ce5eccdbafb6026106c49691674dba
> parent 904a871a628c42031c3093c2b90bde526f0f35f0
> author Harald Welte <laforge@netfilter.org> Wed, 01 Feb 2006 21:29:32 +0100
> committer Harald Welte <laforge@netfilter.org> Wed, 01 Feb 2006 21:29:32 +0100
> 
>  include/net/netfilter/nf_conntrack_helper.h |   10 ++--
>  net/netfilter/nf_conntrack_core.c           |   72 +++++++++++++++++++++++----
>  net/netfilter/nf_conntrack_ftp.c            |   12 ++---
>  3 files changed, 70 insertions(+), 24 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
> index 86ec817..3cca3c8 100644
> --- a/include/net/netfilter/nf_conntrack_helper.h
> +++ b/include/net/netfilter/nf_conntrack_helper.h
> @@ -15,7 +15,7 @@ struct module;
>  
>  struct nf_conntrack_helper
>  {	
> -	struct list_head list; 		/* Internal use. */
> +	struct hlist_node list;		/* Internal use. */
>  
>  	const char *name;		/* name of the module */
>  	struct module *me;		/* pointer to self */
> @@ -23,10 +23,10 @@ struct nf_conntrack_helper
>  					 * expected connections */
>  	unsigned int timeout;		/* timeout for expecteds */
>  
> -	/* Mask of things we will help (compared against server response) */
> -	struct nf_conntrack_tuple tuple;
> -	struct nf_conntrack_tuple mask;
> -	
> +	union nf_conntrack_man_proto l4;
> +	u_int8_t l4proto;
> +	u_int8_t l3proto;

Just a remark if this patch goes forward. The bits to make
nf_conntrack_netlink work with this new layout are still missing :(.
Anyway this is not the point now ;)

>  	/* Function to call when data passes; return verdict, or -1 to
>             invalidate. */
>  	int (*help)(struct sk_buff **pskb,
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index f136e0d..451e8b3 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -23,6 +23,8 @@
>   * 26 Jan 2006: Harald Welte <laforge@netfilter.org>
>   * 	- restructure nf_conn (introduce nf_conn_help)
>   * 	- redesign 'features' how they were originally intended
> + * 02 Feb 2006: Harald Welte <laforge@netfilter.org>
> + * 	- replace tuple/mask helper lookup by more efficient method
>   *
>   * Derived from net/ipv4/netfilter/ip_conntrack_core.c
>   */
> @@ -58,7 +60,7 @@
>  #include <net/netfilter/nf_conntrack_core.h>
>  #include <linux/netfilter_ipv4/listhelp.h>
>  
> -#define NF_CONNTRACK_VERSION	"0.5.0"
> +#define NF_CONNTRACK_VERSION	"0.5.1"
>  
>  #if 0
>  #define DEBUGP printk
> @@ -75,7 +77,6 @@ void (*nf_conntrack_destroyed)(struct nf
>  LIST_HEAD(nf_conntrack_expect_list);
>  struct nf_conntrack_protocol **nf_ct_protos[PF_MAX];
>  struct nf_conntrack_l3proto *nf_ct_l3protos[PF_MAX];
> -static LIST_HEAD(helpers);
>  unsigned int nf_conntrack_htable_size = 0;
>  int nf_conntrack_max;
>  struct list_head *nf_conntrack_hash;
> @@ -85,6 +86,11 @@ unsigned int nf_ct_log_invalid;
>  static LIST_HEAD(unconfirmed);
>  static int nf_conntrack_vmalloc;
>  
> +/* normally the number of helpers is small, so we try to save some cache */
> +#define NFCT_HELPER_BUCKETS 	8
> +#define NFCT_HELPER_INITVAL	0x23424223
> +static struct hlist_head *helpers;

Since the number of helpers is really small, I'm not sure about the
benefits of this patch. The hash calculation adds a constant to the
algorithm complexity that could result in a similar execution time for
this and the current approach. A benchmark could throw some light on this.

What about just killing the tuple and mask fields and keep the current
approach of the helper list?

-- 
Pablo
