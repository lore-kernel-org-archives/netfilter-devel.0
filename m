From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: don't output error message redundantly
Date: Fri, 06 Mar 2015 22:29:53 +0100
Message-ID: <15FC4A3E-A6E5-4008-8DAD-DD9601826A41@trash.net>
References: <53CF53DD.6020308@cn.fujitsu.com> <20140724114946.GA21812@salvia> <C2AFD992-D4FF-4E8A-98D6-209D9C691C18@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Duan Jiong <duanj.fnst@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40348 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbbCFVab (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Mar 2015 16:30:31 -0500
In-Reply-To: <C2AFD992-D4FF-4E8A-98D6-209D9C691C18@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 6. M=C3=A4rz 2015 22:27:09 MEZ, schrieb Patrick McHardy <kaber@trash=
=2Enet>:
>Am 24. Juli 2014 13:49:46 MESZ, schrieb Pablo Neira Ayuso
><pablo@netfilter.org>:
>>On Wed, Jul 23, 2014 at 02:19:09PM +0800, Duan Jiong wrote:
>>>=20
>>> The function led_trigger_register() will only return -EEXIST when
>>> error arises.
>>>=20
>>> Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
>>> ---
>>>  net/netfilter/xt_LED.c | 4 +---
>>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>>=20
>>> diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
>>> index 993de2b..b47a58c 100644
>>> --- a/net/netfilter/xt_LED.c
>>> +++ b/net/netfilter/xt_LED.c
>>> @@ -133,9 +133,7 @@ static int led_tg_check(const struct
>>xt_tgchk_param *par)
>>> =20
>>>  	err =3D led_trigger_register(&ledinternal->netfilter_led_trigger)=
;
>>>  	if (err) {
>>> -		pr_warning("led_trigger_register() failed\n");
>>> -		if (err =3D=3D -EEXIST)
>>> -			pr_warning("Trigger name is already in use.\n");
>>> +		pr_warning("Trigger name is already in use.\n");
>>
>>This should be pr_err() since the rule fails to be loaded if
>>led_trigger_register() fails.
>
>I disagree with this patch, any error and EEXIST are two different
>things.

Sorry didn't notice mails on my tablet were 9 months out oft sync :)

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
