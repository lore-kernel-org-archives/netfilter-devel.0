From: =?UTF-8?Q?Carlos_Falgueras_Garc=c3=ada?= <carlosfg@riseup.net>
Subject: Re: [PATCH 2/4 v3] libnftnl: rule: Change the "userdata" attribute to
 use new TLV buffer
Date: Thu, 10 Mar 2016 22:35:35 +0100
Message-ID: <56E1E8A7.8090302@riseup.net>
References: <1457370643-14408-1-git-send-email-carlosfg@riseup.net>
 <1457370643-14408-3-git-send-email-carlosfg@riseup.net>
 <20160308130450.GA5125@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:44620 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180AbcCJVfn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 16:35:43 -0500
In-Reply-To: <20160308130450.GA5125@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks for the feedback.

On 08/03/16 14:04, Pablo Neira Ayuso wrote:
> On Mon, Mar 07, 2016 at 06:10:42PM +0100, Carlos Falgueras Garc=EDa w=
rote:
>> @@ -75,6 +81,8 @@ void nftnl_rule_free(struct nftnl_rule *r)
>>   		xfree(r->table);
>>   	if (r->chain !=3D NULL)
>>   		xfree(r->chain);
>> +	if (r->flags & (1 << NFTNL_RULE_USERDATA))
>> +		nftnl_udata_free(r->userdata);
>>
>>   	xfree(r);
>>   }
>> @@ -162,8 +170,12 @@ void nftnl_rule_set_data(struct nftnl_rule *r, =
uint16_t attr,
>>   		r->position =3D *((uint64_t *)data);
>>   		break;
>>   	case NFTNL_RULE_USERDATA:
>> -		r->user.data =3D (void *)data;
>> -		r->user.len =3D data_len;
>
> You have to check here if r->userdata is already set, if so, release
> it in first place.
>
>> +		(r->userdata =3D nftnl_udata_alloc(data_len));
>                  ^                                         ^
>
> You don't need these parens.
>

Sorry, I'll remove them.

>> +		if (!r->userdata) {
>> +			perror("nftnl_rule_set_data - userdata");
>> +			return;
>> +		}
>> +		nftnl_udata_copy_data(r->userdata, data, data_len);
>>   		break;
>>   	}
>>   	r->flags |=3D (1 << attr);
>> @@ -221,8 +233,8 @@ const void *nftnl_rule_get_data(const struct nft=
nl_rule *r, uint16_t attr,
>>   		*data_len =3D sizeof(uint64_t);
>>   		return &r->position;
>>   	case NFTNL_RULE_USERDATA:
>> -		*data_len =3D r->user.len;
>> -		return r->user.data;
>> +		*data_len =3D nftnl_udata_len(r->userdata);
>> +		return (void *)nftnl_udata_data(r->userdata);
>>   	}
>>   	return NULL;
>>   }
>> @@ -288,8 +300,9 @@ void nftnl_rule_nlmsg_build_payload(struct nlmsg=
hdr *nlh, struct nftnl_rule *r)
>>   	if (r->flags & (1 << NFTNL_RULE_POSITION))
>>   		mnl_attr_put_u64(nlh, NFTA_RULE_POSITION, htobe64(r->position));
>>   	if (r->flags & (1 << NFTNL_RULE_USERDATA)) {
>> -		mnl_attr_put(nlh, NFTA_RULE_USERDATA, r->user.len,
>> -			     r->user.data);
>> +		mnl_attr_put(nlh, NFTA_RULE_USERDATA,
>> +			     nftnl_udata_len(r->userdata),
>> +			     nftnl_udata_data(r->userdata));
>>   	}
>>
>>   	if (!list_empty(&r->expr_list)) {
>> @@ -447,19 +460,17 @@ int nftnl_rule_nlmsg_parse(const struct nlmsgh=
dr *nlh, struct nftnl_rule *r)
>>   		r->flags |=3D (1 << NFTNL_RULE_POSITION);
>>   	}
>>   	if (tb[NFTA_RULE_USERDATA]) {
>> +		uint16_t udata_size;
>
> Missing line break after this.
>

Thanks, I'll correct it.

>>   		const void *udata =3D
>>   			mnl_attr_get_payload(tb[NFTA_RULE_USERDATA]);
>>
>> -		if (r->user.data)
>> -			xfree(r->user.data);
>
> These lines above are now gone, they avoid a memory leak.
>

I'll check these two cases using the flags. Is it ok?

if (r->flags & (1 << NFTNL_RULE_USERDATA))
nftnl_udata_free(r->userdata);

>> -
>> -		r->user.len =3D mnl_attr_get_payload_len(tb[NFTA_RULE_USERDATA]);
>> +		udata_size =3D mnl_attr_get_payload_len(tb[NFTA_RULE_USERDATA]);
>>
>> -		r->user.data =3D malloc(r->user.len);
>> -		if (r->user.data =3D=3D NULL)
>> +		(r->userdata =3D nftnl_udata_alloc(udata_size));
>                  ^                                           ^
>
> No need for parens.
>

Sorry, I'll fix it.

>> +		if (!r->userdata)
>>   			return -1;
>> +		nftnl_udata_copy_data(r->userdata, udata, udata_size);
>>
>> -		memcpy(r->user.data, udata, r->user.len);
>>   		r->flags |=3D (1 << NFTNL_RULE_USERDATA);
>>   	}
>>
>> @@ -481,6 +492,7 @@ int nftnl_jansson_parse_rule(struct nftnl_rule *=
r, json_t *tree,
>>   	uint64_t uval64;
>>   	uint32_t uval32;
>>   	int i, family;
>> +	struct nftnl_udata_buf *buf;
>>
>>   	root =3D nftnl_jansson_get_node(tree, "rule", err);
>>   	if (root =3D=3D NULL)
>> @@ -557,6 +569,27 @@ int nftnl_jansson_parse_rule(struct nftnl_rule =
*r, json_t *tree,
>>   		nftnl_rule_add_expr(r, e);
>>   	}
>>
>> +	array =3D json_object_get(root, "userdata");
>> +	if (array !=3D NULL) {
>> +		buf =3D nftnl_udata_alloc(NFT_USERDATA_MAXLEN);
>> +		if (!buf) {
>> +			perror("nftnl_jansson_parse_rule");
>> +			goto err;
>> +		}
>> +
>> +		for (i =3D 0; i < json_array_size(array); ++i) {
>> +			if (nftnl_jansson_udata_parse(buf,
>> +						      json_array_get(array, i),
>> +						      err,
>> +						      set_list) < 0)
>> +				goto err;
>> +		}
>> +
>> +		nftnl_rule_set_data(r, NFTNL_RULE_USERDATA,
>> +				    nftnl_udata_data(buf),
>> +				    nftnl_udata_len(buf));
>> +	}
>> +
>>   	return 0;
>>   err:
>>   	return -1;
>> @@ -592,7 +625,7 @@ int nftnl_mxml_rule_parse(mxml_node_t *tree, str=
uct nftnl_rule *r,
>>   			struct nftnl_parse_err *err,
>>   			struct nftnl_set_list *set_list)
>>   {
>> -	mxml_node_t *node;
>> +	mxml_node_t *node, *node_ud;
>>   	struct nftnl_expr *e;
>>   	const char *table, *chain;
>>   	int family;
>> @@ -649,6 +682,35 @@ int nftnl_mxml_rule_parse(mxml_node_t *tree, st=
ruct nftnl_rule *r,
>>   		nftnl_rule_add_expr(r, e);
>>   	}
>>
>> +	node_ud =3D mxmlFindElement(tree, tree, "userdata", NULL, NULL,
>> +				  MXML_DESCEND);
>
> You better wrap this code into a function in the mxml.c file as you
> will need this later on for sets too. Same thing for the json code.
>

Done.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
