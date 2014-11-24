From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [ebtables-compat-experimental5 PATCH] iptables: xtables-eb: fix
 renaming of chains
Date: Mon, 24 Nov 2014 19:27:40 +0100
Message-ID: <CAOkSjBha3BuK0HvwSgp+9-xcRrHfbxKasrOcne91ZOJEVY7kzg@mail.gmail.com>
References: <20141120120931.24603.59259.stgit@nfdev.cica.es> <20141120122033.GA11615@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Giuseppe Longo <giuseppelng@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:34612 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaKXS2B convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:28:01 -0500
Received: by mail-lb0-f182.google.com with SMTP id f15so6888218lbj.41
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Nov 2014 10:28:00 -0800 (PST)
In-Reply-To: <20141120122033.GA11615@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20 November 2014 at 13:20, Pablo Neira Ayuso <pablo@netfilter.org> w=
rote:
> On Thu, Nov 20, 2014 at 01:09:32PM +0100, Arturo Borrero Gonzalez wro=
te:
>> Renaming of chains is not working. and ebtables-compat gets:
>>  libnftnl: attribute 0 assertion failed in chain.c:159
>
> Thanks for catching up this.
>
>> This patch brings back the parser code of the original ebtables tool=
:
>>  http://git.netfilter.org/ebtables.old-history/tree/userspace/ebtabl=
es2/ebtables.c#n652
>>
>> I adaped the original parser code to fit in the new environment, plu=
s fixing
>> style issues.
>> In the nft backend, some minor changes are needed to support this op=
eration,
>> for example to avoid calling the nf_tables API with NLM_F_EXCL.
>>
>> I also tried to keep original error messages as much as possible.
>>
>> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.co=
m>
>> ---
>>  iptables/nft.c                   |   12 +++++++++++-
>>  iptables/xtables-eb-standalone.c |    2 +-
>>  iptables/xtables-eb.c            |   33 +++++++++++++++++++++++++++=
++++--
>>  3 files changed, 43 insertions(+), 4 deletions(-)
>>
>> diff --git a/iptables/nft.c b/iptables/nft.c
>> index 4ee22c5..7cd56ef 100644
>> --- a/iptables/nft.c
>> +++ b/iptables/nft.c
>> @@ -253,6 +253,7 @@ enum obj_update_type {
>>       NFT_COMPAT_CHAIN_USER_ADD,
>>       NFT_COMPAT_CHAIN_USER_DEL,
>>       NFT_COMPAT_CHAIN_UPDATE,
>> +     NFT_COMPAT_CHAIN_RENAME,
>>       NFT_COMPAT_RULE_APPEND,
>>       NFT_COMPAT_RULE_INSERT,
>>       NFT_COMPAT_RULE_REPLACE,
>> @@ -1508,10 +1509,15 @@ int nft_chain_user_rename(struct nft_handle =
*h,const char *chain,
>>       uint64_t handle;
>>       int ret;
>>
>> +     nft_fn =3D nft_chain_user_add;
>> +
>>       /* If built-in chains don't exist for this table, create them =
*/
>>       if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
>>               nft_xt_builtin_init(h, table);
>>
>> +     /* Config load changed errno. Ensure genuine info for our call=
ers. */
>> +     errno =3D 0;
>> +
>>       /* Find the old chain to be renamed */
>>       c =3D nft_chain_find(h, table, chain);
>>       if (c =3D=3D NULL) {
>> @@ -1530,7 +1536,7 @@ int nft_chain_user_rename(struct nft_handle *h=
,const char *chain,
>>       nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_HANDLE, handle);
>>
>>       if (h->batch_support) {
>> -             ret =3D batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, =
c);
>> +             ret =3D batch_chain_add(h, NFT_COMPAT_CHAIN_RENAME, c)=
;
>>       } else {
>>               char buf[MNL_SOCKET_BUFFER_SIZE];
>>               struct nlmsghdr *nlh;
>> @@ -2279,6 +2285,10 @@ static int nft_action(struct nft_handle *h, i=
nt action)
>>                                                    NLM_F_CREATE : 0,
>>                                                  seq++, n->chain);
>>                       break;
>> +             case NFT_COMPAT_CHAIN_RENAME:
>> +                     nft_compat_chain_batch_add(h, NFT_MSG_NEWCHAIN=
, 0,
>> +                                                seq++, n->chain);
>> +                     break;
>>               case NFT_COMPAT_RULE_APPEND:
>>                       nft_compat_rule_batch_add(h, NFT_MSG_NEWRULE,
>>                                                 NLM_F_CREATE | NLM_F=
_APPEND,
>
> Please, send me a separated patch so I can merge this to master.
>
>> diff --git a/iptables/xtables-eb-standalone.c b/iptables/xtables-eb-=
standalone.c
>> index 1c3cbf0..740a420 100644
>> --- a/iptables/xtables-eb-standalone.c
>> +++ b/iptables/xtables-eb-standalone.c
>> @@ -84,7 +84,7 @@ int xtables_eb_main(int argc, char *argv[])
>>               ret =3D nft_commit(&h);
>>
>>       if (!ret)
>> -             fprintf(stderr, "%s\n", nft_strerror(errno));
>> +             xtables_error(OTHER_PROBLEM, "%s\n", nft_strerror(errn=
o));
>
> IIRC error reporting in ebtables differs from iptables. The output
> should look the same. We're currently using nft_strerror() but I gues=
s
> we'll need a ebt_strerror() function.
>

I've tried to collect ebtables original errors. Most of them uses
arguments, for example:
 * Can't delete the chain 'test', it's referenced in chain 'FORWARD', r=
ule 0.
 * Loop from chain 'test2' to chain 'test'.

So, that ebt_strerror() function seems almost useless.

I will resend this patch with the changes you requested. I guess we
can revisit that issue in the future.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
