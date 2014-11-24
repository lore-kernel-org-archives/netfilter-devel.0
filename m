From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [ebtables-compat-experimental5 PATCH] iptables: xtables-eb:
 user-defined chains default policy is always RETURN
Date: Mon, 24 Nov 2014 10:46:57 +0100
Message-ID: <CAOkSjBgr8UicdN80fvtMjiASWC-AWZUr-EG4MuaQqs3VvH34iQ@mail.gmail.com>
References: <20141119131147.15524.18916.stgit@nfdev.cica.es> <20141120120718.GA9745@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Giuseppe Longo <giuseppelng@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:44513 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbaKXJrT convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:47:19 -0500
Received: by mail-la0-f51.google.com with SMTP id mc6so7182209lab.24
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Nov 2014 01:47:18 -0800 (PST)
In-Reply-To: <20141120120718.GA9745@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20 November 2014 at 13:07, Pablo Neira Ayuso <pablo@netfilter.org> w=
rote:
>> @@ -1146,9 +1147,17 @@ check_extension: */
>>       cs.fw.ethproto =3D htons(cs.fw.ethproto);
>>
>>       if (command =3D=3D 'P') {
>> -             if (selected_chain < NF_BR_NUMHOOKS && strcmp(policy, =
"RETURN")=3D=3D0)
>> +             if (selected_chain < 0) {
>>                       xtables_error(PARAMETER_PROBLEM,
>> -                                   "Policy RETURN only allowed for =
user defined chains");
>> +                                   "Default policy in user-defined"
>> +                                   " chains is mandatory RETURN");
>
> Wait.
>
> This changes the existing behaviour. I mean, this check rejects rules
> using RETURN from base chains, that should still be there to mimic
> ebtables behaviour. Why change this?
>

I don't see such behaviour change:

Bridge chain: test2, entries: 2, policy: RETURN
-i eth0 -j ACCEPT
-i eth0 -j RETURN

I can still use rules with RETURN target.

The change is in the -P path, not in -j.

>> +             }
>> +             if (strcmp(policy, "ACCEPT") !=3D 0 &&
>> +                 strcmp(policy, "DROP") !=3D 0) {
>> +                     xtables_error(PARAMETER_PROBLEM,
>> +                                   "Default policy in default chain=
s"
>> +                                   " is either ACCEPT or DROP");
>
> Please use the same error message the ebtables uses:
>
> "Policy RETURN only allowed for user defined chains");
>
> And explicitly check for RETURN instead. This is a compat tool, we
> should spot the same errors than the original.
>

Ok, sending v2.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
