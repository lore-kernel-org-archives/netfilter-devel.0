From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC,
	NETFILTER]: amanda helper: convert to textsearch infrastructure
Date: Wed, 24 May 2006 02:28:24 +0200
Message-ID: <4473A8A8.3040801@netfilter.org>
References: <446DF48C.5020109@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <446DF48C.5020109@trash.net>
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

Patrick McHardy wrote:
> I've just converted the amanda helper to the textsearch infrastructure
> to fix a packet corruption bug. This allows to avoid the data copying
> and save roughly 64k of memory. The IRC helper looks like a good
> candidate for this too, FTP is probably quite a bit more complicated.

It looks fine, just two minor comments. BTW, thanks for doing this: This 
port is on my TODO list since the workshop.

> ------------------------------------------------------------------------
> 
> [NETFILTER]: amanda helper: convert to textsearch infrastructure
> 
> When a port number within a packet is replaced by a differently sized
> number only the packet is resized, but not the copy of the data.
> Following port numbers are rewritten based on their offsets within
> the copy, leading to packet corruption.
> 
> Convert the amanda helper to the textsearch infrastructure to avoid
> the copy entirely.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>
> 
> ---
> commit 23b9a4b7fd6c16efd069b1b4de6e605fdc56634c
> tree 0145077411b1866778a745d14805baaa7d5f290f
> parent a54c9d30dbb06391ec4422aaf0e1dc2c8c53bd3e
> author Patrick McHardy <kaber@trash.net> Fri, 19 May 2006 18:30:54 +0200
> committer Patrick McHardy <kaber@trash.net> Fri, 19 May 2006 18:30:54 +0200
> 
>  net/ipv4/netfilter/Kconfig               |    2 
>  net/ipv4/netfilter/ip_conntrack_amanda.c |  140 ++++++++++++++++++++----------
>  2 files changed, 93 insertions(+), 49 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
> index 3d560de..d859754 100644
> --- a/net/ipv4/netfilter/Kconfig
> +++ b/net/ipv4/netfilter/Kconfig
> @@ -142,6 +142,8 @@ config IP_NF_TFTP
>  config IP_NF_AMANDA
>  	tristate "Amanda backup protocol support"
>  	depends on IP_NF_CONNTRACK
> +	select TEXTSEARCH
> +	select TEXTSEARCH_KMP
>  	help
>  	  If you are running the Amanda backup package <http://www.amanda.org/>
>  	  on this machine or machines that will be MASQUERADED through this
> diff --git a/net/ipv4/netfilter/ip_conntrack_amanda.c b/net/ipv4/netfilter/ip_conntrack_amanda.c
> index a604b1c..34b2309 100644
> --- a/net/ipv4/netfilter/ip_conntrack_amanda.c
> +++ b/net/ipv4/netfilter/ip_conntrack_amanda.c
> @@ -17,17 +17,16 @@
>   *	this value.
>   *
>   */
> -
> -#include <linux/in.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> -#include <linux/netfilter.h>
> -#include <linux/ip.h>
>  #include <linux/moduleparam.h>
> +#include <linux/textsearch.h>
> +#include <linux/skbuff.h>
> +#include <linux/in.h>
> +#include <linux/ip.h>
>  #include <linux/udp.h>
> -#include <net/checksum.h>
> -#include <net/udp.h>
>  
> +#include <linux/netfilter.h>
>  #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
>  #include <linux/netfilter_ipv4/ip_conntrack_amanda.h>
>  
> @@ -39,12 +38,6 @@ MODULE_LICENSE("GPL");
>  module_param(master_timeout, uint, 0600);
>  MODULE_PARM_DESC(master_timeout, "timeout for the master connection");
>  
> -static const char *conns[] = { "DATA ", "MESG ", "INDEX " };
> -
> -/* This is slow, but it's simple. --RR */
> -static char *amanda_buffer;
> -static DEFINE_SPINLOCK(amanda_buffer_lock);
> -
>  unsigned int (*ip_nat_amanda_hook)(struct sk_buff **pskb,
>  				   enum ip_conntrack_info ctinfo,
>  				   unsigned int matchoff,
> @@ -52,12 +45,48 @@ unsigned int (*ip_nat_amanda_hook)(struc
>  				   struct ip_conntrack_expect *exp);
>  EXPORT_SYMBOL_GPL(ip_nat_amanda_hook);
>  
> +enum amanda_strings {
> +	SEARCH_CONNECT,
> +	SEARCH_NEWLINE,
> +	SEARCH_DATA,
> +	SEARCH_MESG,
> +	SEARCH_INDEX,
> +};
> +
> +static struct {
> +	char			*string;
> +	size_t			len;
> +	struct ts_config	*ts;
> +} search[] = {
> +	[SEARCH_CONNECT] = {
> +		.string	= "CONNECT ",
> +		.len	= 8,
> +	},
> +	[SEARCH_NEWLINE] = {
> +		.string	= "\n",
> +		.len	= 1,
> +	},
> +	[SEARCH_DATA] = {
> +		.string	= "DATA ",
> +		.len	= 5,
> +	},
> +	[SEARCH_MESG] = {
> +		.string	= "MESG ",
> +		.len	= 5,
> +	},
> +	[SEARCH_INDEX] = {
> +		.string = "INDEX ",
> +		.len	= 6,
> +	},
> +};
> +
>  static int help(struct sk_buff **pskb,
>                  struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)
>  {
> +	struct ts_state ts;
>  	struct ip_conntrack_expect *exp;
> -	char *data, *data_limit, *tmp;
> -	unsigned int dataoff, i;
> +	unsigned int dataoff, start, stop, off, i;
> +	char pbuf[sizeof("65535")], *tmp;
>  	u_int16_t port, len;
>  	int ret = NF_ACCEPT;
>  
> @@ -77,29 +106,34 @@ static int help(struct sk_buff **pskb,
>  		return NF_ACCEPT;
>  	}
>  
> -	spin_lock_bh(&amanda_buffer_lock);
> -	skb_copy_bits(*pskb, dataoff, amanda_buffer, (*pskb)->len - dataoff);
> -	data = amanda_buffer;
> -	data_limit = amanda_buffer + (*pskb)->len - dataoff;
> -	*data_limit = '\0';
> -
> -	/* Search for the CONNECT string */
> -	data = strstr(data, "CONNECT ");
> -	if (!data)
> +	memset(&ts, 0, sizeof(ts));
> +	start = skb_find_text(*pskb, dataoff, (*pskb)->len,
> +			      search[SEARCH_CONNECT].ts, &ts);
> +	if (start == UINT_MAX)
>  		goto out;
> -	data += strlen("CONNECT ");
> +	start += dataoff + search[SEARCH_CONNECT].len;
>  
> -	/* Only search first line. */	
> -	if ((tmp = strchr(data, '\n')))
> -		*tmp = '\0';
> +	memset(&ts, 0, sizeof(ts));
> +	stop = skb_find_text(*pskb, start, (*pskb)->len,
> +			     search[SEARCH_NEWLINE].ts, &ts);

Better use strstr here: the textsearch infrastructure implements 
algorithms only introduce trade off for patterns longer than one byte. 
So, in this case, the infrastructure can not help in any way.

> +	if (stop == UINT_MAX)
> +		goto out;
> +	stop += start;
>  
> -	for (i = 0; i < ARRAY_SIZE(conns); i++) {
> -		char *match = strstr(data, conns[i]);
> -		if (!match)
> +	for (i = SEARCH_DATA; i <= SEARCH_INDEX; i++) {
> +		memset(&ts, 0, sizeof(ts));
> +		off = skb_find_text(*pskb, start, stop, search[i].ts, &ts);
> +		if (off == UINT_MAX)
>  			continue;
> -		tmp = data = match + strlen(conns[i]);
> -		port = simple_strtoul(data, &data, 10);
> -		len = data - tmp;
> +		off += start + search[i].len;
> +
> +		len = min_t(unsigned int, sizeof(pbuf) - 1, stop - off);
> +		if (skb_copy_bits(*pskb, off, pbuf, len))
> +			break;
> +		pbuf[len] = '\0';
> +
> +		port = simple_strtoul(pbuf, &tmp, 10);
> +		len = tmp - pbuf;
>  		if (port == 0 || len > 5)
>  			break;
>  
> @@ -125,8 +159,7 @@ static int help(struct sk_buff **pskb,
>  		exp->mask.dst.u.tcp.port = 0xFFFF;
>  
>  		if (ip_nat_amanda_hook)
> -			ret = ip_nat_amanda_hook(pskb, ctinfo,
> -						 tmp - amanda_buffer,
> +			ret = ip_nat_amanda_hook(pskb, ctinfo, off - dataoff,
>  						 len, exp);
>  		else if (ip_conntrack_expect_related(exp) != 0)
>  			ret = NF_DROP;
> @@ -134,12 +167,11 @@ static int help(struct sk_buff **pskb,
>  	}
>  
>  out:
> -	spin_unlock_bh(&amanda_buffer_lock);
>  	return ret;
>  }
>  
>  static struct ip_conntrack_helper amanda_helper = {
> -	.max_expected = ARRAY_SIZE(conns),
> +	.max_expected = 3,
>  	.timeout = 180,
>  	.me = THIS_MODULE,
>  	.help = help,
> @@ -155,26 +187,36 @@ static struct ip_conntrack_helper amanda
>  
>  static void __exit ip_conntrack_amanda_fini(void)
>  {
> +	int i;
> +
>  	ip_conntrack_helper_unregister(&amanda_helper);
> -	kfree(amanda_buffer);
> +	for (i = 0; i < ARRAY_SIZE(search); i++)
> +		textsearch_destroy(search[i].ts);
>  }
>  
>  static int __init ip_conntrack_amanda_init(void)
>  {
> -	int ret;
> -
> -	amanda_buffer = kmalloc(65536, GFP_KERNEL);
> -	if (!amanda_buffer)
> -		return -ENOMEM;
> -
> -	ret = ip_conntrack_helper_register(&amanda_helper);
> -	if (ret < 0) {
> -		kfree(amanda_buffer);
> -		return ret;
> +	int ret, i;
> +
> +	ret = -ENOMEM;
> +	for (i = 0; i < ARRAY_SIZE(search); i++) {
> +		search[i].ts = textsearch_prepare("kmp", search[i].string,
> +						  search[i].len,
> +						  GFP_KERNEL, TS_AUTOLOAD);

I think that the algorithm should be configurable. Although Boyer-Moore 
would not find a matching if the traffic is defragmented (see the header 
of /lib/ts_bm.c), it definitely scales better, so some sysadmins could 
increase performance to the detriment of defragmented traffic:

http://people.netfilter.org/~pablo/textsearch/

I have an old patch for the FTP helper here somewhere, I could give it 
some spins and send it to you.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
