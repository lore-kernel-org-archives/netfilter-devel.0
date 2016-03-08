From: =?UTF-8?Q?Carlos_Falgueras_Garc=c3=ada?= <carlosfg@riseup.net>
Subject: Re: [PATCH 2/3 v2] libnftnl: rule: Change the "userdata" attribute to
 use new TLV buffer.
Date: Tue, 8 Mar 2016 10:58:11 +0100
Message-ID: <56DEA233.5000907@riseup.net>
References: <1456763140-15121-1-git-send-email-carlosfg@riseup.net>
 <1456763140-15121-2-git-send-email-carlosfg@riseup.net>
 <20160302184129.GC1351@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:58512 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071AbcCHJ6O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2016 04:58:14 -0500
In-Reply-To: <20160302184129.GC1351@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/03/16 19:41, Pablo Neira Ayuso wrote:
> On Mon, Feb 29, 2016 at 05:25:39PM +0100, Carlos Falgueras Garc=EDa w=
rote:
>
> Please, wrap these code below into a function, eg. nftnl_jansson_udat=
a_parse()
>
>> +	array =3D json_object_get(root, "userdata");
>> +	if (array =3D=3D NULL) {
>> +		err->error =3D NFTNL_PARSE_EMISSINGNODE;
>> +		err->node_name =3D "userdata";
>> +		goto err;
>> +	}
>> +
>> +	attrbuf =3D nftnl_attrbuf_alloc(NFT_USERDATA_MAXLEN);
>> +	if (!attrbuf) {
>> +		perror("nftnl_jansson_parse_rule");
>> +		exit(EXIT_FAILURE);
>> +	}
>> +
>> +	for (i =3D 0; i < json_array_size(array); ++i) {
>> +		if (nftnl_jansson_attr_parse(attrbuf,
>> +					     json_array_get(array, i),
>> +					     err,
>> +					     set_list) < 0)
>> +			goto err;
>> +	}
>> +
>> +	nftnl_rule_set_data(r, NFTNL_RULE_USERDATA,
>> +			    nftnl_attrbuf_get_data(attrbuf),
>> +			    nftnl_attrbuf_get_len(attrbuf));
>> +
>>   	return 0;
>>   err:
>>   	return -1;
>> @@ -592,7 +629,7 @@ int nftnl_mxml_rule_parse(mxml_node_t *tree, str=
uct nftnl_rule *r,
>>   			struct nftnl_parse_err *err,
>>   			struct nftnl_set_list *set_list)
>>   {
>> -	mxml_node_t *node;
>> +	mxml_node_t *node, *node_ud;
>>   	struct nftnl_expr *e;
>>   	const char *table, *chain;
>>   	int family;
>> @@ -649,6 +686,35 @@ int nftnl_mxml_rule_parse(mxml_node_t *tree, st=
ruct nftnl_rule *r,
>>   		nftnl_rule_add_expr(r, e);
>>   	}
>>
>> +	node_ud =3D mxmlFindElement(tree, tree, "userdata", NULL, NULL,
>> +				  MXML_DESCEND);
>> +	if (node_ud) {
>
> Please, wrap these code below into a function, eg. nftnl_mxml_udata_p=
arse()
>
>> +		struct nftnl_attrbuf *attrbuf;
>> +
>> +		attrbuf =3D nftnl_attrbuf_alloc(NFT_USERDATA_MAXLEN);
>> +		if (!attrbuf) {
>> +			perror("nftnl_mxml_rule_parse");
>> +			exit(EXIT_FAILURE);
>> +		}
>> +
>> +		/* Iterate over attributes */
>> +		for (
>> +			node =3D mxmlFindElement(node_ud, node_ud, "attr", NULL,
>> +				NULL, MXML_DESCEND);
>> +			node !=3D NULL;
>> +			node =3D mxmlFindElement(node, node_ud, "attr", NULL,
>> +				NULL, MXML_DESCEND)
>> +		) {
>> +			if (nftnl_mxml_attr_parse(attrbuf, node,
>> +					MXML_DESCEND_FIRST, r->flags, err) < 0)
>> +				return -1;
>> +		}
>> +
>> +		nftnl_rule_set_data(r, NFTNL_RULE_USERDATA,
>> +				    nftnl_attrbuf_get_data(attrbuf),
>> +				    nftnl_attrbuf_get_len(attrbuf));
>> +	}
>> +
>>   	return 0;
>>   }
>>   #endif
>> @@ -711,6 +777,21 @@ int nftnl_rule_parse_file(struct nftnl_rule *r,=
 enum nftnl_parse_type type,
>>   }
>>   EXPORT_SYMBOL_ALIAS(nftnl_rule_parse_file, nft_rule_parse_file);
>>
>> +static size_t nftnl_rule_snprintf_data2str(char *buf, size_t size,
>> +					   const void *data, size_t datalen)
>> +{
>> +	int i;
>> +	size_t ret, len =3D size, offset =3D 0;
>> +	const unsigned char *str =3D data;
>> +
>> +	for (i =3D 0; i < datalen; i++) {
>> +		ret =3D snprintf(buf+offset, len, "%02X", str[i]);
>> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>> +	}
>> +
>> +	return offset;
>> +}
>> +
>>   static int nftnl_rule_snprintf_json(char *buf, size_t size, struct=
 nftnl_rule *r,
>>   					 uint32_t type, uint32_t flags)
>>   {
>> @@ -757,6 +838,31 @@ static int nftnl_rule_snprintf_json(char *buf, =
size_t size, struct nftnl_rule *r
>>   		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>>   	}
>>
>> +	if (r->flags & (1 << NFTNL_RULE_USERDATA)) {
>> +		const struct nftnl_attr *attr;
>> +
>> +		ret =3D snprintf(buf+offset, len, "\"userdata\":[");
>> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>> +
>> +		nftnl_attr_for_each(attr, r->userdata) {
>> +			ret =3D nftnl_rule_snprintf_json_attr(buf+offset, len,
>> +							    attr);
>> +			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>> +
>> +			ret =3D snprintf(buf+offset, len, ",");
>> +			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>> +		}
>> +		/* delete last comma */
>> +		buf[offset-1] =3D '\0';
>> +		offset--;
>> +		size--;
>> +		len++;
>> +
>> +		ret =3D snprintf(buf+offset, len, "],\n");
>> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>> +
>> +	}
>> +
>>   	ret =3D snprintf(buf+offset, len, "\"expr\":[");
>>   	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>>
>> @@ -849,17 +955,123 @@ static int nftnl_rule_snprintf_xml(char *buf,=
 size_t size, struct nftnl_rule *r,
>>   		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>>
>>   	}
>> +
>> +	if (r->flags & (1 << NFTNL_RULE_USERDATA)) {
>> +		const struct nftnl_attr *attr;
>> +
>> +		ret =3D snprintf(buf+offset, len, "<userdata>");
>> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>> +
>> +		nftnl_attr_for_each(attr, r->userdata) {
>> +			ret =3D snprintf(buf+offset, len, "<attr>");
>> +			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>> +
>> +			ret =3D nftnl_rule_snprintf_xml_attr(buf+offset, len,
>> +							    attr);
>> +			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>> +
>> +			ret =3D snprintf(buf+offset, len, "</attr>");
>> +			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>> +		}
>> +
>> +		ret =3D snprintf(buf+offset, len, "</userdata>");
>> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>> +	}
>> +
>>   	ret =3D snprintf(buf+offset, len, "</rule>");
>>   	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>>
>>   	return offset;
>>   }
>>
>> +static size_t nftnl_rule_snprintf_xml_attr(char *buf, size_t size,
>> +					   const struct nftnl_attr *attr)
> [...]
>> +static size_t nftnl_rule_snprintf_json_attr(char *buf, size_t size,
>> +					    const struct nftnl_attr *attr)
>
> You can consolidate these two functions into one using the NFTNL_BUF_=
*
> API.
>

If I wrap these functions in this patch, the new code structure will=20
differ from the one already there. Maybe it is better if I do a complet=
e=20
refactor in a different patch?

>> diff --git a/src/utils.c b/src/utils.c
>> index ba36bc4..0cac4b6 100644
>> --- a/src/utils.c
>> +++ b/src/utils.c
>> @@ -139,6 +139,51 @@ int nftnl_strtoi(const char *string, int base, =
void *out, enum nftnl_type type)
>>   	return ret;
>>   }
>>
>> +static int hex2char(char *out, char c)
>> +{
>> +	/* numbers */
>> +	if (c >=3D 0x30 && c <=3D 0x39)
>> +		*out =3D c - 0x30;
>> +	/* lowercase characters */
>> +	else if (c >=3D 0x61 && c <=3D 0x66)
>> +		*out =3D c - 0x61 + 10;
>> +	/* uppercase characters */
>> +	else if (c >=3D 0x41 && c <=3D 0x46)
>> +		*out =3D c - 0x41 + 10;
>> +	else {
>> +		errno =3D EINVAL;
>> +		return 0;
>> +	}
>
> You can just print data in hexadecimal, so we can get rid of this.
>

This functions is not for print, it is for parse an hexadecimal=20
character (maybe i must find a better name?). I'm printing the user dat=
a=20
in hexadecimal with snprintf("%02X") and later I'm parsing it character=
=20
by character with this function. There is other possible solutions with=
=20
strtoul, atoi or sscanf, but these can't convert a single byte so they=20
are endian dependient.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
