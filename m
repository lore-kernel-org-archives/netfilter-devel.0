From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [ebtables-compat-experimental5 PATCH v2] iptables: xtables-eb:
 user-defined chains default policy is always RETURN
Date: Mon, 24 Nov 2014 13:12:33 +0100
Message-ID: <CAOkSjBj2ejY=rVcGhaBJ7uPP=a_Fzj5qrbnMLtB22P61V_7i9Q@mail.gmail.com>
References: <20141124095149.17111.54015.stgit@nfdev.cica.es> <20141124111251.GA9308@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Giuseppe Longo <giuseppelng@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:51622 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbaKXMMz convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 07:12:55 -0500
Received: by mail-la0-f42.google.com with SMTP id s18so7547833lam.29
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Nov 2014 04:12:53 -0800 (PST)
In-Reply-To: <20141124111251.GA9308@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24 November 2014 at 12:12, Pablo Neira Ayuso <pablo@netfilter.org> w=
rote:
> On Mon, Nov 24, 2014 at 10:52:04AM +0100, Arturo Borrero Gonzalez wro=
te:
>> The RETURN default policy is mandatory in user-defined chains.
>> Builtin chains must have one of ACCEPT or DROP.
>>
>> So, with this patch, ebtables-compat ends with:
>>
>> Command:                      Result:
>>
>> -L                            Always RETURN for user-defined chains
>> -P builtin RETURN             Policy RETURN only allowed for user de=
fined chains
>> -P builtin ACCEPT|DROP                ok
>> -P userdefined RETURN         Default policy in user-defined chains =
is mandatory RETURN
>> -P userdefined ACCEPT|DROP    Default policy in user-defined chains =
is mandatory RETURN
>> -N userdefined                        ok
>> -N userdefined -P RETURN      Default policy in user-defined chains =
is mandatory RETURN
>> -N userdefined -P ACCEPT|DROP Default policy in user-defined chains =
is mandatory RETURN
>>
>> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.co=
m>
>> ---
>> v2: change some error messages, as requested by Pablo.
>>
>>  iptables/nft-bridge.c |    3 ++-
>>  iptables/xtables-eb.c |    9 ++++++++-
>>  2 files changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
>> index b5aec00..a1bd906 100644
>> --- a/iptables/nft-bridge.c
>> +++ b/iptables/nft-bridge.c
>> @@ -356,7 +356,8 @@ static void nft_bridge_print_header(unsigned int=
 format, const char *chain,
>>                                   const struct xt_counters *counters=
,
>>                                   bool basechain, uint32_t refs)
>>  {
>> -     printf("Bridge chain: %s, entries: %u, policy: %s\n", chain, r=
efs, pol);
>> +     printf("Bridge chain: %s, entries: %u, policy: %s\n",
>> +            chain, refs, basechain ? pol : "RETURN");
>>  }
>>
>>  static void nft_bridge_print_firewall(struct nft_rule *r, unsigned =
int num,
>> diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
>> index 917bca2..e462dbf 100644
>> --- a/iptables/xtables-eb.c
>> +++ b/iptables/xtables-eb.c
>> @@ -616,6 +616,7 @@ int do_commandeb(struct nft_handle *h, int argc,=
 char *argv[], char **table)
>>               case 'E': /* Rename chain */
>>               case 'X': /* Delete chain */
>>                       /* We allow -N chainname -P policy */
>> +                     /* XXX: Not in ebtables-compat */
>>                       if (command =3D=3D 'N' && c =3D=3D 'P') {
>>                               command =3D c;
>>                               optind--; /* No table specified */
>> @@ -1146,9 +1147,15 @@ check_extension: */
>>       cs.fw.ethproto =3D htons(cs.fw.ethproto);
>>
>>       if (command =3D=3D 'P') {
>> -             if (selected_chain < NF_BR_NUMHOOKS && strcmp(policy, =
"RETURN")=3D=3D0)
>> +             if (selected_chain < 0) {
>> +                     xtables_error(PARAMETER_PROBLEM,
>> +                                   "Default policy in user-defined"
>> +                                   " chains is mandatory RETURN");
>
> The intended error should something like:
>
> ... , "Policy %s only allowed from base chains", policy);
>
> right? I can mangle the patch here. Thanks.

Ok, thanks.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
