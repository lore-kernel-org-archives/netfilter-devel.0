From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] iptables/libiptc perf issue: Finding jump chains
 is	suboptimal
Date: Wed, 28 Nov 2007 09:36:41 +0100
Message-ID: <474D2899.3090607@trash.net>
References: <1196085406.3866.59.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@vger.kernel.org>,
	Harald Welte <laforge@netfilter.org>,
	"Paul C. Diem" <PCDiem@FoxValley.net>,
	Martin Josefsson <gandalf@netfilter.org>
To: jdb@comx.dk
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39932 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbXK1Igt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Nov 2007 03:36:49 -0500
In-Reply-To: <1196085406.3866.59.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jesper Dangaard Brouer wrote:
> Performance optimize scalability issue:
>    Finding jump chains is suboptimal O(Chain*Rules).
> 
> diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
> index e7ffb01..e611178 100644
> --- a/libiptc/libiptc.c
> +++ b/libiptc/libiptc.c
> @@ -307,13 +307,20 @@ static struct rule_head *iptcc_get_rule_num_reverse(struct chain_head *c,
>  static struct chain_head *
>  iptcc_find_chain_by_offset(TC_HANDLE_T handle, unsigned int offset)
>  {
> -	struct list_head *pos;
> -
>  	if (list_empty(&handle->chains))
>  		return NULL;
>  
> -	list_for_each(pos, &handle->chains) {
> -		struct chain_head *c = list_entry(pos, struct chain_head, list);
> +	/* Find the entry pointed to by offset */
> +	STRUCT_ENTRY * e = iptcb_offset2entry(handle, offset);
> +
> +	/* When parsing the blob (in cache_add_entry), the entry
> +	   field comefrom has been modified to contain a pointer
> +	   to the chain it belongs to.
> +	*/
> +	struct chain_head *c = (struct chain_head *)e->comefrom;


As you mentioned in your other mail, this unfortunately doesn't
work on 64 bit since comefrom is an unsigned int and thus can't
hold a pointer. What might work (though pretty ugly) is splitting
up the pointer between nfcache and comefrom. This might need some
changes to the deletion code to make sure nfcache is not compared
on deletion.
