From: =?windows-1252?Q?=C1lvaro_Neira_Ayuso?= <alvaroneay@gmail.com>
Subject: Re: [nft PATCH v3 2/2] src: add import command
Date: Tue, 10 Mar 2015 19:19:22 +0100
Message-ID: <54FF35AA.3030104@gmail.com>
References: <1425981858-10687-1-git-send-email-alvaroneay@gmail.com> <20150310102107.GB27395@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:40703 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbbCJSS7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Mar 2015 14:18:59 -0400
Received: by wevk48 with SMTP id k48so3729055wev.7
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2015 11:18:58 -0700 (PDT)
In-Reply-To: <20150310102107.GB27395@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

El 10/03/15 a las 11:21, Pablo Neira Ayuso escribi=F3:
> On Tue, Mar 10, 2015 at 11:04:18AM +0100, Alvaro Neira Ayuso wrote:
>> diff --git a/src/rule.c b/src/rule.c
>> index 8d76fd0..8c58a2b 100644
>> --- a/src/rule.c
>> +++ b/src/rule.c
>> @@ -20,6 +20,7 @@
>>   #include <rule.h>
>>   #include <utils.h>
>>   #include <netlink.h>
>> +#include <mnl.h>
>>
>>   #include <libnftnl/common.h>
>>   #include <libnftnl/ruleset.h>
>> @@ -555,6 +556,21 @@ void export_free(struct export *e)
>>   	xfree(e);
>>   }
>>
>> +struct import *import_alloc(uint32_t format)
>> +{
>> +	struct import *import;
>> +
>> +	import =3D xmalloc(sizeof(struct import));
>> +	import->format =3D format;
>> +
>> +	return import;
>> +}
>> +
>> +void import_free(struct import *i)
>> +{
>> +	xfree(i);
>> +}
>> +
>>   struct monitor *monitor_alloc(uint32_t format, uint32_t type, cons=
t char *event)
>>   {
>>   	struct monitor *mon;
>> @@ -599,6 +615,9 @@ void cmd_free(struct cmd *cmd)
>>   		case CMD_OBJ_MONITOR:
>>   			monitor_free(cmd->monitor);
>>   			break;
>> +		case CMD_OBJ_IMPORT:
>> +			import_free(cmd->import);
>> +			break;
>>   		case CMD_OBJ_EXPORT:
>>   			export_free(cmd->export);
>>   			break;
>> @@ -1006,6 +1025,322 @@ static int do_command_describe(struct netlin=
k_ctx *ctx, struct cmd *cmd)
>>   	return 0;
>>   }
>>
>> +struct ruleset_parse {
>> +	struct netlink_ctx *nl_ctx;
>> +	struct cmd *cmd;
>> +};
>> +
>> +static int ruleset_parse_setelems(const struct nft_parse_ctx *ctx)
>> +{
>> +	const struct ruleset_parse *rp;
>> +	struct nft_set *set;
>> +	uint32_t cmd;
>> +	int ret =3D -1;
>> +
>> +	set =3D nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_SET);
>> +	rp =3D nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_DATA);
>> +
>> +	cmd =3D nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_CMD);
>> +	switch (cmd) {
>> +	case NFT_CMD_ADD:
>> +		ret =3D mnl_nft_setelem_batch_add(set, 0, rp->nl_ctx->seqnum);
>> +		break;
>> +	case NFT_CMD_DELETE:
>> +		ret =3D mnl_nft_setelem_batch_del(set, 0, rp->nl_ctx->seqnum);
>> +		break;
>> +	default:
>> +		errno =3D EOPNOTSUPP;
>> +		break;
>> +	}
>> +
>> +	if (ret < 0)
>> +		netlink_io_error(rp->nl_ctx, &rp->cmd->location,
>> +				 "Could not import set_elems: %s",
>> +				 strerror(errno));
>
> I think rp->cmd->location is unset, so this will crash. Could you
> validate this by forcing an error to make sure it works?

It's not unset. If we have an error, the location is in the import=20
command. For example:

Error: Could not import set_elems: Invalid argument
import json
^^^^^^^^^^^
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
