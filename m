Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AFFAC7618B
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 10:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7123218DA
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 10:52:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="lQ/dWEI7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbfGYKwm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 06:52:42 -0400
Received: from mx1.riseup.net ([198.252.153.129]:39112 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728232AbfGYKwm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 06:52:42 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 37DF71A1EC5;
        Thu, 25 Jul 2019 03:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1564051961; bh=zqd2Kc+vLxMcU14Zm2oazwG0wK0pdkz2bAtnLv8Nih0=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=lQ/dWEI7Dlt6n7jeVrpOb9giTk155QbGZCrA/TPsx60YfLHQ8/uTa2J3iIAAxB3Wb
         3gEYGlZGjo4Xst/7anIvWmMn+6qu1zZoRRpKW8+dsSPXJrQt/fCzXHXJOjkEN3eN6u
         Ru+tvNsyRGleutOUO9PnpL9kBcYoUOWOjmdgm5Ic=
X-Riseup-User-ID: 82527F956AD50A0F114235EACADAA61BD7E38B17DABEF1D7F1EC84652F3CBB71
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 9616B1209E1;
        Thu, 25 Jul 2019 03:52:40 -0700 (PDT)
Date:   Thu, 25 Jul 2019 12:52:27 +0200
In-Reply-To: <20190725104425.2byt6gwruopkpqx6@salvia>
References: <20190722160236.12516-1-ffmancera@riseup.net> <20190722160236.12516-3-ffmancera@riseup.net> <20190725104425.2byt6gwruopkpqx6@salvia>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 2/2 nft] src: allow variable in chain policy
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     netfilter-devel@vger.kernel.org
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Message-ID: <D3F77CA3-7F92-4865-AC99-32A9A88A65A3@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

El 25 de julio de 2019 12:44:25 CEST, Pablo Neira Ayuso <pablo@netfilter=
=2Eorg> escribi=C3=B3:
>On Mon, Jul 22, 2019 at 06:02:39PM +0200, Fernando Fernandez Mancera
>wrote:
>> This patch introduces the use of nft input files variables in chain
>policy=2E
>> e=2Eg=2E
>>=20
>> define default_policy =3D "accept"
>>=20
>> add table ip foo
>> add chain ip foo bar {type filter hook input priority filter; policy
>$default_policy}
>>=20
>> table ip foo {
>> 	chain bar {
>> 		type filter hook input priority filter; policy accept;
>> 	}
>> }
>>=20
>> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup=2Enet>
>> ---
>>  include/rule=2Eh                                |  2 +-
>>  src/evaluate=2Ec                                | 51
>+++++++++++++++++++
>>  src/json=2Ec                                    |  5 +-
>>  src/mnl=2Ec                                     |  9 ++--
>>  src/netlink=2Ec                                 |  8 ++-
>>  src/parser_bison=2Ey                            | 19 +++++--
>>  src/parser_json=2Ec                             | 17 +++++--
>>  src/rule=2Ec                                    | 13 +++--
>>  =2E=2E=2E/testcases/nft-f/0025policy_variable_0     | 17 +++++++
>>  =2E=2E=2E/testcases/nft-f/0026policy_variable_0     | 17 +++++++
>>  =2E=2E=2E/testcases/nft-f/0027policy_variable_1     | 18 +++++++
>>  =2E=2E=2E/testcases/nft-f/0028policy_variable_1     | 18 +++++++
>>  =2E=2E=2E/nft-f/dumps/0025policy_variable_0=2Enft     |  5 ++
>>  =2E=2E=2E/nft-f/dumps/0026policy_variable_0=2Enft     |  5 ++
>>  14 files changed, 186 insertions(+), 18 deletions(-)
>>  create mode 100755 tests/shell/testcases/nft-f/0025policy_variable_0
>>  create mode 100755 tests/shell/testcases/nft-f/0026policy_variable_0
>>  create mode 100755 tests/shell/testcases/nft-f/0027policy_variable_1
>>  create mode 100755 tests/shell/testcases/nft-f/0028policy_variable_1
>>  create mode 100644
>tests/shell/testcases/nft-f/dumps/0025policy_variable_0=2Enft
>>  create mode 100644
>tests/shell/testcases/nft-f/dumps/0026policy_variable_0=2Enft
>>=20
>> diff --git a/include/rule=2Eh b/include/rule=2Eh
>> index c6e8716=2E=2Eb12165a 100644
>> --- a/include/rule=2Eh
>> +++ b/include/rule=2Eh
>> @@ -209,7 +209,7 @@ struct chain {
>>  	const char		*hookstr;
>>  	unsigned int		hooknum;
>>  	struct prio_spec	priority;
>> -	int			policy;
>> +	struct expr		*policy;
>>  	const char		*type;
>>  	const char		*dev;
>>  	struct scope		scope;
>> diff --git a/src/evaluate=2Ec b/src/evaluate=2Ec
>> index d2faee8=2E=2E4d8bfbf 100755
>> --- a/src/evaluate=2Ec
>> +++ b/src/evaluate=2Ec
>> @@ -3415,6 +3415,52 @@ static uint32_t str2hooknum(uint32_t family,
>const char *hook)
>>  	return NF_INET_NUMHOOKS;
>>  }
>> =20
>> +static bool evaluate_policy(struct eval_ctx *ctx, struct expr
>**policy)
>
>better rename static bool =2E=2E=2E(=2E=2E=2E, struct expr **exprp)
>
>> +{
>> +	char policy_str[NFT_NAME_MAXLEN];
>> +	struct location loc;
>> +	int policy_num;
>
>so you can use 'int policy;'=2E
>
>> +	ctx->ectx=2Elen =3D NFT_NAME_MAXLEN * BITS_PER_BYTE;
>> +	if (expr_evaluate(ctx, policy) < 0)
>> +		return false;
>
>probably cache this here:
>
>        expr =3D *exprp;
>
>so you don't need:
>
>        (*expr)->=2E=2E=2E
>
>in all this code below=2E
>
>> +	if ((*policy)->etype !=3D EXPR_VALUE) {
>> +		expr_error(ctx->msgs, *policy, "%s is not a valid "
>> +			   "policy expression", expr_name(*policy));
>> +		return false;
>> +	}
>> +
>> +	if ((*policy)->dtype->type =3D=3D TYPE_STRING) {
>> +		mpz_export_data(policy_str, (*policy)->value,
>> +				BYTEORDER_HOST_ENDIAN,
>> +				NFT_NAME_MAXLEN);
>> +		loc =3D (*policy)->location;
>> +		if (!strcmp(policy_str, "accept")) {
>> +			expr_free(*policy);
>> +			policy_num =3D NF_ACCEPT;
>> +			*policy =3D constant_expr_alloc(&loc,
>> +						      &integer_type,
>> +						      BYTEORDER_HOST_ENDIAN,
>> +						      sizeof(int) * BITS_PER_BYTE,
>> +						      &policy_num);
>> +		} else if (!strcmp(policy_str, "drop")) {
>> +			expr_free(*policy);
>> +			policy_num =3D NF_DROP;
>> +			*policy =3D constant_expr_alloc(&(*policy)->location,
>> +						      &integer_type,
>> +						      BYTEORDER_HOST_ENDIAN,
>> +						      sizeof(int) * BITS_PER_BYTE,
>> +						      &policy_num);
>
>Probably:
>
>		if (!strcmp(policy_str, "accept")) {
>                        policy =3D NF_ACCEPT;
>                else (!strmp(policy_str, "drop")) {
>                        policy =3D NF_DROP;
>                } else {
>                        =2E=2E=2E
>                }
>
>                expr =3D constant_expr_alloc(=2E=2E=2E);
>
>so this code becomes shorter and easier to read=2E
>
>And I think you should do all this from the new policy_datype, not
>from the evaluation phase itself=2E
>
>Thanks=2E

I agree with everything except this part=2E There is no policy datatype=2E=
 I could create it if you prefer it=2E Thanks! :-)
