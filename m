Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00A45C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 May 2022 18:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241763AbiEPSRA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 May 2022 14:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344677AbiEPSQ5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 May 2022 14:16:57 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 75103BF57
        for <netfilter-devel@vger.kernel.org>; Mon, 16 May 2022 11:16:56 -0700 (PDT)
Date:   Mon, 16 May 2022 20:16:53 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_rbtree: Move clauses for expired nodes, last
 active node as leaf
Message-ID: <YoKVFRR1gggECpiZ@salvia>
References: <20220512183421.712556-1-sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="rgwOcYTrypfmBggK"
Content-Disposition: inline
In-Reply-To: <20220512183421.712556-1-sbrivio@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--rgwOcYTrypfmBggK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Stefano,

On Thu, May 12, 2022 at 08:34:21PM +0200, Stefano Brivio wrote:
> In the overlap detection performed as part of the insertion operation,
> we have to skip nodes that are not active in the current generation or
> expired. This was done by adding several conditions in overlap decision
> clauses, which made it hard to check for correctness, and debug the
> actual issue this patch is fixing.
> 
> Consolidate these conditions into a single clause, so that we can
> proceed with debugging and fixing the following issue.
> 
> Case b3. described in comments covers the insertion of a start
> element after an existing end, as a leaf. If all the descendants of
> a given element are inactive, functionally, for the purposes of
> overlap detection, we still have to treat this as a leaf, but we don't.
> 
> If, in the same transaction, we remove a start element to the right,
> remove an end element to the left, and add a start element to the right
> of an existing, active end element, we don't hit case b3. For example:
> 
> - existing intervals: 1-2, 3-5, 6-7
> - transaction: delete 3-5, insert 4-5
> 
> node traversal might happen as follows:
> - 2 (active end)
> - 5 (inactive end)
> - 3 (inactive start)
> 
> when we add 4 as start element, we should simply consider 2 as
> preceding end, and consider it as a leaf, because interval 3-5 has been
> deleted. If we don't, we'll report an overlap because we forgot about
> this.
> 
> Add an additional flag which is set as we find an active end, and reset
> it if we find an active start (to the left). If we finish the traversal
> with this flag set, it means we need to functionally consider the
> previous active end as a leaf, and allow insertion instead of reporting
> overlap.

I can still trigger EEXIST with deletion of existing interval. It
became harder to reproduce after this patch.

After hitting EEXIST, if I do:

        echo "flush ruleset" > test.nft
        nft list ruleset >> test.nft

to dump the existing ruleset, then I run the delete element command
again to remove the interval and it works. Before this patch I could
reproduce it by reloading an existing ruleset dump.

I'm running the script that I'm attaching manually, just one manual
invocation after another.

I ocassionally hit ENOBUFS, but that sounds like a different issue
that I'm looking into.

Thanks.

> Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
>  net/netfilter/nft_set_rbtree.c | 92 ++++++++++++++++++++--------------
>  1 file changed, 54 insertions(+), 38 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
> index 7325bee7d144..dc2184bbe722 100644
> --- a/net/netfilter/nft_set_rbtree.c
> +++ b/net/netfilter/nft_set_rbtree.c
> @@ -222,6 +222,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
>  	bool overlap = false, dup_end_left = false, dup_end_right = false;
>  	struct nft_rbtree *priv = nft_set_priv(set);
>  	u8 genmask = nft_genmask_next(net);
> +	bool last_left_node_is_end = false;
>  	struct nft_rbtree_elem *rbe;
>  	struct rb_node *parent, **p;
>  	int d;
> @@ -287,80 +288,95 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
>  		d = memcmp(nft_set_ext_key(&rbe->ext),
>  			   nft_set_ext_key(&new->ext),
>  			   set->klen);
> -		if (d < 0) {
> +
> +		if (d < 0)
>  			p = &parent->rb_left;
> +		else if (d > 0)
> +			p = &parent->rb_right;
> +		else if (nft_rbtree_interval_end(rbe))
> +			p = &parent->rb_left;
> +		else
> +			p = &parent->rb_right;
>  
> +		/* There might be inactive elements in the tree: ignore them by
> +		 * traversing them without affecting flags.
> +		 *
> +		 * We need to reset the dup_end_left and dup_end_right flags,
> +		 * though, because those only apply to adjacent nodes.
> +		 */
> +		if (!nft_set_elem_active(&rbe->ext, genmask) ||
> +		    nft_set_elem_expired(&rbe->ext)) {
> +			dup_end_left = dup_end_right = false;
> +			continue;
> +		}
> +
> +		if (d < 0) {
>  			if (nft_rbtree_interval_start(new)) {
> -				if (nft_rbtree_interval_end(rbe) &&
> -				    nft_set_elem_active(&rbe->ext, genmask) &&
> -				    !nft_set_elem_expired(&rbe->ext) && !*p)
> -					overlap = false;
> +				/* See case b3. described above.
> +				 *
> +				 * If this is not a leaf, but all nodes below
> +				 * this one are inactive, except for a leaf, we
> +				 * still have to consider it a leaf for the
> +				 * purposes of overlap detection.
> +				 *
> +				 * Set last_left_node_is_end if this is not a
> +				 * leaf and an active end element, and reset it
> +				 * if we find an active start element to the
> +				 * left.
> +				 *
> +				 * If we end the traversal with this flag set,
> +				 * this node is a leaf for the purposes of case
> +				 * b3., and no overlap will be reported.
> +				 */
> +				if (nft_rbtree_interval_end(rbe)) {
> +					if (!*p)
> +						overlap = false;
> +					else
> +						last_left_node_is_end = true;
> +				} else {
> +					last_left_node_is_end = false;
> +				}
>  			} else {
> +
>  				if (dup_end_left && !*p)
>  					return -ENOTEMPTY;
>  
> -				overlap = nft_rbtree_interval_end(rbe) &&
> -					  nft_set_elem_active(&rbe->ext,
> -							      genmask) &&
> -					  !nft_set_elem_expired(&rbe->ext);
> -
> +				overlap = nft_rbtree_interval_end(rbe);
>  				if (overlap) {
>  					dup_end_right = true;
>  					continue;
>  				}
>  			}
>  		} else if (d > 0) {
> -			p = &parent->rb_right;
> -
>  			if (nft_rbtree_interval_end(new)) {
>  				if (dup_end_right && !*p)
>  					return -ENOTEMPTY;
>  
> -				overlap = nft_rbtree_interval_end(rbe) &&
> -					  nft_set_elem_active(&rbe->ext,
> -							      genmask) &&
> -					  !nft_set_elem_expired(&rbe->ext);
> -
> +				overlap = nft_rbtree_interval_end(rbe);
>  				if (overlap) {
>  					dup_end_left = true;
>  					continue;
>  				}
> -			} else if (nft_set_elem_active(&rbe->ext, genmask) &&
> -				   !nft_set_elem_expired(&rbe->ext)) {
> +			} else {
>  				overlap = nft_rbtree_interval_end(rbe);
>  			}
>  		} else {
>  			if (nft_rbtree_interval_end(rbe) &&
>  			    nft_rbtree_interval_start(new)) {
> -				p = &parent->rb_left;
> -
> -				if (nft_set_elem_active(&rbe->ext, genmask) &&
> -				    !nft_set_elem_expired(&rbe->ext))
> -					overlap = false;
> +				overlap = false;
>  			} else if (nft_rbtree_interval_start(rbe) &&
>  				   nft_rbtree_interval_end(new)) {
> -				p = &parent->rb_right;
> -
> -				if (nft_set_elem_active(&rbe->ext, genmask) &&
> -				    !nft_set_elem_expired(&rbe->ext))
> -					overlap = false;
> -			} else if (nft_set_elem_active(&rbe->ext, genmask) &&
> -				   !nft_set_elem_expired(&rbe->ext)) {
> +				overlap = false;
> +			} else {
>  				*ext = &rbe->ext;
>  				return -EEXIST;
> -			} else {
> -				overlap = false;
> -				if (nft_rbtree_interval_end(rbe))
> -					p = &parent->rb_left;
> -				else
> -					p = &parent->rb_right;
>  			}
>  		}
>  
>  		dup_end_left = dup_end_right = false;
>  	}
>  
> -	if (overlap)
> +	if (overlap && !last_left_node_is_end)
>  		return -ENOTEMPTY;
>  
>  	rb_link_node_rcu(&new->node, parent, p);
> -- 
> 2.35.1
> 

--rgwOcYTrypfmBggK
Content-Type: application/x-sh
Content-Disposition: attachment; filename="rbtree-bug.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A=0Aset -e=0A=0ARULESET=3D"table inet x {=0A	set y {=0A		type =
inet_service=0A		flags interval=0A		auto-merge=0A	}=0A}"=0A=0Anft -f - <<< =
$RULESET=0A=0Atmpfile=3D$(mktemp)=0Aecho $tmpfile=0Aecho -n "add element in=
et x y { " > $tmpfile=0Afor ((i=3D0;i<65535;i+=3D2))=0Ado=0A	echo -n "$i, "=
 >> $tmpfile=0A	if [ $i -eq 65534 ]=0A	then=0A		echo -n "$i" >> $tmpfile=0A=
	fi=0Adone=0Aecho "}" >> $tmpfile=0A=0Anft -f $tmpfile=0A=0Atmpfile2=3D$(mk=
temp)=0Aecho $tmpfile2=0Afor ((i=3D1;i<65535;i+=3D2))=0Ado=0A	echo "$i" >> =
$tmpfile2=0Adone=0A=0Atmpfile3=3D$(mktemp)=0Aecho $tmpfile3=0Ashuf $tmpfile=
2 > $tmpfile3=0Ai=3D0=0Acat $tmpfile3 | while read line && [ $i -lt 10 ]=0A=
do=0A	time nft add element inet x y { $line }=0A	i=3D$((i+1))=0Adone=0A=0Af=
or ((i=3D0;i<10;i++))=0Ado=0A	from=3D$(($RANDOM%65535))=0A	to=3D$(($from+10=
0))=0A	echo "$from-$to"=0A	nft add element inet x y { $from-$to }=0A	nft ge=
t element inet x y { $from-$to }=0A	from2=3D$(($from+10))=0A	to2=3D$(($to-1=
0))=0A	echo "$from, $to, $from2-$to2"=0A	nft delete element inet x y { $fro=
m, $to, $from2-$to2 }=0A	from=3D$(($from+1))=0A	nft get element inet x y { =
$from }=0A	to=3D$(($to-1))=0A	nft get element inet x y { $to }=0A	from2=3D$=
(($from2-1))=0A	echo $from2=0A	nft get element inet x y { $from2 }=0A	to2=
=3D$(($to2+1))=0A	echo $to2=0A	nft get element inet x y { $to2 }=0Adone=0A
--rgwOcYTrypfmBggK--
