From: =?windows-1252?Q?=C1lvaro_Neira_Ayuso?= <alvaroneay@gmail.com>
Subject: Re: [nft PATCH v3 2/2] src: add import command
Date: Tue, 10 Mar 2015 19:13:48 +0100
Message-ID: <54FF345C.9040307@gmail.com>
References: <1425981858-10687-1-git-send-email-alvaroneay@gmail.com> <20150310103737.GC4538@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37913 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbbCJSNZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Mar 2015 14:13:25 -0400
Received: by widex7 with SMTP id ex7so31763523wid.3
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2015 11:13:24 -0700 (PDT)
In-Reply-To: <20150310103737.GC4538@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

El 10/03/15 a las 11:37, Patrick McHardy escribi=F3:
> On 10.03, Alvaro Neira Ayuso wrote:
>> @@ -275,6 +279,13 @@ struct export {
>>   struct export *export_alloc(uint32_t format);
>>   void export_free(struct export *e);
>>
>> +struct import {
>> +	uint32_t	format;
>> +};
>> +
>> +struct import *import_alloc(uint32_t format);
>> +void import_free(struct import *i);
>
> How about a common struct for both commands? "format", "import_export=
",
> ...
>

Nice idea Patrick. I'm going to do it.

>> +import_cmd		:	import_format
>
> Same here, please change export_format to something common.
>
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
>
> This would be a BUG, no? Same question for all similar cases.

I don't think so. If the user are in another kernel that one operation=20
is not supported, we will say that it's a bug and I think it's better t=
o=20
say only that the operation is not supported. Maybe my point of view is=
=20
wrong, I'm opened to change it if you think that it's better to show a=20
bug message.

>
>> +static int do_command_import(struct netlink_ctx *ctx, struct cmd *c=
md)
>> +{
>> +	int ret;
>> +	struct nft_parse_err *err;
>> +	struct ruleset_parse rp =3D {
>> +		.nl_ctx =3D ctx,
>> +		.cmd =3D cmd
>
> Please align, makes it easier to read.

Catched.

>
>> +	ret =3D nft_ruleset_parse_file_cb(cmd->import->format, stdin, err,=
 &rp,
>> +					ruleset_parse_cb);
>> +	if (ret < 0)
>> +		nft_parse_perror("unable to import. Parsing failed", err);
>
> I'd suggest a ": parsing failed", makes it clear that its only a sing=
le
> error, not two.

Perfect, I'm going to change it too.

Thanks for the review to Pablo and Patrick. I'm going to work in the=20
changes.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
