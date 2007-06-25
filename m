From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 03/10] nf_conntrack: Use extension infrastructure for
 helper
Date: Mon, 25 Jun 2007 12:06:18 +0200
Message-ID: <467F939A.9080907@trash.net>
References: <200706250314.l5P3EmZD019561@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, netfilter-devel@lists.netfilter.org,
	pablo@netfilter.org, kadlec@blackhole.kfki.hu
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200706250314.l5P3EmZD019561@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> --- a/include/net/netfilter/nf_conntrack_extend.h
> +++ b/include/net/netfilter/nf_conntrack_extend.h
> @@ -5,9 +5,12 @@
>  
>  enum nf_ct_ext_id
>  {
> +	NF_CT_EXT_HELPER,
>  	NF_CT_EXT_MAX,
>  } __attribute__((packed));


Don't use attribute packed please, just use an u8 if you want to
make sure it doesn't need more space than that.

Minor nitpick: it would be more logical if max would be the
highest value, not highest value + 1. The array should then
be declared with size max + 1. But thats just my preference,
half the code out there seems to use max + 1 as maximum, so
keep it if you like.
