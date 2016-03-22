From: =?UTF-8?Q?Carlos_Falgueras_Garc=c3=ada?= <carlosfg@riseup.net>
Subject: Re: [PATCH 4/4 v5] nftables: rule: Change the field "rule->comment"
 for an nftnl_udata_buf
Date: Tue, 22 Mar 2016 12:37:25 +0100
Message-ID: <56F12E75.7030609@riseup.net>
References: <1458073687-23870-1-git-send-email-carlosfg@riseup.net>
 <1458073687-23870-4-git-send-email-carlosfg@riseup.net>
 <20160321221330.GA2534@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:53017 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759045AbcCVLh3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Mar 2016 07:37:29 -0400
In-Reply-To: <20160321221330.GA2534@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21/03/16 23:13, Pablo Neira Ayuso wrote:
> On Tue, Mar 15, 2016 at 09:28:07PM +0100, Carlos Falgueras Garc=EDa w=
rote:
>> Now it is possible to store multiple variable length user data into =
rule.
>> Modify the parser in order to fill the nftnl_udata with the comment,=
 and
>> the print function for extract these commentary and print it to user=
=2E
>>
>> Signed-off-by: Carlos Falgueras Garc=EDa <carlosfg@riseup.net>
>> ---
>>   include/rule.h            |  7 +++++++
>>   src/netlink_delinearize.c | 52 +++++++++++++++++++++++++++++++++++=
++++++++++--
>>   src/netlink_linearize.c   | 16 +++++++++++++--
>>   3 files changed, 71 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/rule.h b/include/rule.h
>> index c848f0f..b52f0ac 100644
>> --- a/include/rule.h
>> +++ b/include/rule.h
>> @@ -4,6 +4,7 @@
>>   #include <stdint.h>
>>   #include <nftables.h>
>>   #include <list.h>
>> +#include <libnftnl/udata.h>
>>
>>   /**
>>    * struct handle - handle for tables, chains, rules and sets
>> @@ -396,4 +397,10 @@ extern int do_command(struct netlink_ctx *ctx, =
struct cmd *cmd);
>>   extern int cache_update(enum cmd_ops cmd, struct list_head *msgs);
>>   extern void cache_release(void);
>>
>> +enum udata_type {
>> +	UDATA_TYPE_COMMENT,
>> +	__UDATA_TYPE_MAX,
>> +};
>> +#define UDATA_TYPE_MAX (__UDATA_TYPE_MAX - 1)
>> +
>>   #endif /* NFTABLES_RULE_H */
>> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
>> index d431588..5fcb5c1 100644
>> --- a/src/netlink_delinearize.c
>> +++ b/src/netlink_delinearize.c
>> @@ -25,6 +25,7 @@
>>   #include <utils.h>
>>   #include <erec.h>
>>   #include <sys/socket.h>
>> +#include <libnftnl/udata.h>
>>
>>   struct netlink_parse_ctx {
>>   	struct list_head	*msgs;
>> @@ -1746,6 +1747,54 @@ static void rule_parse_postprocess(struct net=
link_parse_ctx *ctx, struct rule *r
>>   	}
>>   }
>>
>> +static int parse_udata_cb(const struct nftnl_udata *attr, void *dat=
a)
>> +{
>> +	unsigned char *value =3D nftnl_udata_attr_value(attr);
>> +	uint8_t type =3D nftnl_udata_attr_type(attr);
>> +	uint8_t len =3D nftnl_udata_attr_len(attr);
>> +	const struct nftnl_udata **tb =3D data;
>> +
>> +	switch (type) {
>> +	case UDATA_TYPE_COMMENT:
>> +		if (value[len - 1] !=3D '\0')
>> +			return -1;
>> +		break;
>> +	default:
>> +		break;
>> +	};
>> +
>> +	tb[type] =3D attr;
>> +	return 1;
>> +}
>> +
>> +static char *udata_get_comment(const void *data, uint32_t data_len)
>> +{
>> +	const struct nftnl_udata *tb[UDATA_TYPE_MAX + 1] =3D {};
>> +	struct nftnl_udata_buf *udata;
>> +	uint8_t attr_len;
>> +	char *comment =3D NULL;
>> +
>> +	udata =3D nftnl_udata_alloc(data_len);
>> +	if (!udata)
>> +		memory_allocation_error();
>> +	nftnl_udata_copy_data(udata, data, data_len);
>> +
>> +	if (nftnl_udata_parse(udata, parse_udata_cb, tb) <=3D 0)
>> +		goto exit;
>
> I think this should be instead:
>
> 	if (nftnl_udata_parse(data, data_len, parse_udata_cb, tb) <=3D 0)
>
> So you don't need to allocate the buffer then copy data into it.
>
> I think the buffer infrastructure is only necessary to build the TLV
> attributes, not to parse it.
>

Ok.

>> +	if (!tb[UDATA_TYPE_COMMENT])
>> +		goto exit;
>> +
>> +	attr_len =3D nftnl_udata_attr_len(tb[UDATA_TYPE_COMMENT]);
>> +	comment =3D xmalloc(attr_len);
>> +	memcpy(comment, nftnl_udata_attr_value(tb[UDATA_TYPE_COMMENT]),
>> +	       attr_len);
>
> I'd suggest:
>
>          comment =3D xstrdup(nftnl_udata_attr_get_str(tb[UDATA_TYPE_C=
OMMENT]));

I'll change this.

>> +
>> +exit:
>> +	nftnl_udata_free(udata);
>> +	return comment;
>> +}
>> +
>>   struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
>>   				      const struct nftnl_rule *nlr)
>>   {
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
