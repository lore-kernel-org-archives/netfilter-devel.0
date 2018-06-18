From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH nf-next v4] net: netfilter: nf_tables_api: Use
 id allocation.
Date: Mon, 18 Jun 2018 15:25:20 +0300
Message-ID: <20180618122520.iotrrrjgbykixtkr@mwanda>
References: <20180613164143.19232-1-rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Varsha Rao <rvarsha016@gmail.com>, netfilter-devel@vger.kernel.org,
 kbuild-all@01.org, Pablo Neira Ayuso <pablo@netfilter.org>
To: kbuild@01.org, Varsha Rao <rvarsha016@gmail.com>
Return-path: <kbuild-bounces@lists.01.org>
Content-Disposition: inline
In-Reply-To: <20180613164143.19232-1-rvarsha016@gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/kbuild/>
List-Post: <mailto:kbuild@lists.01.org>
List-Help: <mailto:kbuild-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=subscribe>
Errors-To: kbuild-bounces@lists.01.org
Sender: "kbuild" <kbuild-bounces@lists.01.org>
List-Id: netfilter-devel.vger.kernel.org

Hi Varsha,

Thank you for the patch! Perhaps something to improve:

url:    https://github.com/0day-ci/linux/commits/Varsha-Rao/net-netfilter-nf_tables_api-Use-id-allocation/20180614-004233
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master

New smatch warnings:
net/netfilter/nf_tables_api.c:2962 nf_tables_set_alloc_name() error: uninitialized symbol 'id'.

Old smatch warnings:
net/netfilter/nf_tables_api.c:4314 nft_add_set_elem() error: uninitialized symbol 'ext2'.

# https://github.com/0day-ci/linux/commit/c19707b85d3d68e8c0fc2a91b2b401832676f224
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout c19707b85d3d68e8c0fc2a91b2b401832676f224
vim +/id +2962 net/netfilter/nf_tables_api.c

c19707b8 Varsha Rao        2018-06-13  2923  
20a69341 Patrick McHardy   2013-10-11  2924  static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
20a69341 Patrick McHardy   2013-10-11  2925  				    const char *name)
20a69341 Patrick McHardy   2013-10-11  2926  {
20a69341 Patrick McHardy   2013-10-11  2927  	const struct nft_set *i;
20a69341 Patrick McHardy   2013-10-11  2928  	const char *p;
c19707b8 Varsha Rao        2018-06-13  2929  	int n = 0, id;
c19707b8 Varsha Rao        2018-06-13  2930  	DEFINE_IDA(inuse);
20a69341 Patrick McHardy   2013-10-11  2931  
38745490 Phil Sutter       2017-07-27  2932  	p = strchr(name, '%');
20a69341 Patrick McHardy   2013-10-11  2933  	if (p != NULL) {
20a69341 Patrick McHardy   2013-10-11  2934  		if (p[1] != 'd' || strchr(p + 2, '%'))
96518518 Patrick McHardy   2013-10-14  2935  			return -EINVAL;
20a69341 Patrick McHardy   2013-10-11  2936  
20a69341 Patrick McHardy   2013-10-11  2937  	list_for_each_entry(i, &ctx->table->sets, list) {
14662917 Daniel Borkmann   2013-12-31  2938  		int tmp;
14662917 Daniel Borkmann   2013-12-31  2939  
37a9cc52 Pablo Neira Ayuso 2016-06-12  2940  		if (!nft_is_active_next(ctx->net, set))
37a9cc52 Pablo Neira Ayuso 2016-06-12  2941  			continue;
14662917 Daniel Borkmann   2013-12-31  2942  		if (!sscanf(i->name, name, &tmp))
20a69341 Patrick McHardy   2013-10-11  2943  			continue;
c19707b8 Varsha Rao        2018-06-13  2944  		if (tmp < 0 || tmp >= NFT_SET_IDA_SIZE)
20a69341 Patrick McHardy   2013-10-11  2945  			continue;
14662917 Daniel Borkmann   2013-12-31  2946  
c19707b8 Varsha Rao        2018-06-13  2947  		n = ida_get_new_above(&inuse, tmp, &id);
c19707b8 Varsha Rao        2018-06-13  2948  		if ((n < 0) && (n != -EAGAIN))
c19707b8 Varsha Rao        2018-06-13  2949  			return n;
20a69341 Patrick McHardy   2013-10-11  2950  	}
c19707b8 Varsha Rao        2018-06-13  2951  	n = ida_get_new_above(&inuse, 0, &id);

Smatch is complaining that if n == -EAGAIN then id isn't initialized
which seems legit.

20a69341 Patrick McHardy   2013-10-11  2952  
c19707b8 Varsha Rao        2018-06-13  2953  	if ((n < 0)  && (n != -EAGAIN)) {
c19707b8 Varsha Rao        2018-06-13  2954  		if (n == -ENOSPC)
c19707b8 Varsha Rao        2018-06-13  2955  			ida_destroy(&inuse);
c19707b8 Varsha Rao        2018-06-13  2956  		return n;
60eb1894 Patrick McHardy   2014-03-07  2957  	}
c19707b8 Varsha Rao        2018-06-13  2958  
c19707b8 Varsha Rao        2018-06-13  2959  		ida_destroy(&inuse);
20a69341 Patrick McHardy   2013-10-11  2960  	}
20a69341 Patrick McHardy   2013-10-11  2961  
c19707b8 Varsha Rao        2018-06-13 @2962  	set->name = kasprintf(GFP_KERNEL, name, id);
38745490 Phil Sutter       2017-07-27  2963  	if (!set->name)
38745490 Phil Sutter       2017-07-27  2964  		return -ENOMEM;
38745490 Phil Sutter       2017-07-27  2965  
20a69341 Patrick McHardy   2013-10-11  2966  	list_for_each_entry(i, &ctx->table->sets, list) {
37a9cc52 Pablo Neira Ayuso 2016-06-12  2967  		if (!nft_is_active_next(ctx->net, i))
37a9cc52 Pablo Neira Ayuso 2016-06-12  2968  			continue;
e63aaaa6 Arvind Yadav      2017-09-20  2969  		if (!strcmp(set->name, i->name)) {
e63aaaa6 Arvind Yadav      2017-09-20  2970  			kfree(set->name);
20a69341 Patrick McHardy   2013-10-11  2971  			return -ENFILE;
20a69341 Patrick McHardy   2013-10-11  2972  		}
e63aaaa6 Arvind Yadav      2017-09-20  2973  	}
96518518 Patrick McHardy   2013-10-14  2974  	return 0;
96518518 Patrick McHardy   2013-10-14  2975  }
20a69341 Patrick McHardy   2013-10-11  2976  
