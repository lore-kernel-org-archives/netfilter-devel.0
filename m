From: Feng Gao <gfree.wind@gmail.com>
Subject: Re: [PATCH nf 1/1] netfilter: ctlink: Fix one possible use-after-free
 in ctnetlink_create_expect
Date: Sat, 18 Mar 2017 12:39:08 +0800
Message-ID: <CA+6hz4pO9o7bGuseR1Bo2ufh8ctKErBEagB2_Cf=B2SBuAME_Q@mail.gmail.com>
References: <1489808770-29622-1-git-send-email-fgao@ikuai8.com> <CA+6hz4qDjNty_=yi0Oj=kfo9xM8s_bcmwOBys+4SSv=s=Nq9oQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Gao Feng <fgao@ikuai8.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, Feng Gao <gfree.wind@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34378 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbdCREjb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 Mar 2017 00:39:31 -0400
Received: by mail-pf0-f196.google.com with SMTP id o126so10629822pfb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 21:39:09 -0700 (PDT)
In-Reply-To: <CA+6hz4qDjNty_=yi0Oj=kfo9xM8s_bcmwOBys+4SSv=s=Nq9oQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 18, 2017 at 12:26 PM, Feng Gao <gfree.wind@gmail.com> wrote:
> Hi Pablo,
>
> On Sat, Mar 18, 2017 at 11:46 AM,  <fgao@ikuai8.com> wrote:
>> From: Gao Feng <fgao@ikuai8.com>
>>
>> There is no rcu_read_lock during ctlink gets the helper and inserts the
>> expectation. So there is one possible use-after-free issue when unload
>> the helper module.
>>
>> For example:
>>
>>         CPU1                                CPU2
>> ctlink gets the helper
>>                             helper module unload and remove all expectat=
ions
>> insert the expectation
>>
>> Now there is one expectation which references one helper whose module is
>> unloaded.
>>
>> Signed-off-by: Gao Feng <fgao@ikuai8.com>
>> ---
>>  net/netfilter/nf_conntrack_netlink.c | 10 ++++++++--
>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_con=
ntrack_netlink.c
>> index 6806b5e..f6d1d63 100644
>> --- a/net/netfilter/nf_conntrack_netlink.c
>> +++ b/net/netfilter/nf_conntrack_netlink.c
>> @@ -3133,23 +3133,27 @@ static int ctnetlink_del_expect(struct net *net,=
 struct sock *ctnl,
>>                 return -ENOENT;
>>         ct =3D nf_ct_tuplehash_to_ctrack(h);
>>
>> +       rcu_read_lock();
>>         if (cda[CTA_EXPECT_HELP_NAME]) {
>>                 const char *helpname =3D nla_data(cda[CTA_EXPECT_HELP_NA=
ME]);
>>
>>                 helper =3D __nf_conntrack_helper_find(helpname, u3,
>>                                                     nf_ct_protonum(ct));
>>                 if (helper =3D=3D NULL) {
>> +                       rcu_read_unlock();
>>  #ifdef CONFIG_MODULES
>>                         if (request_module("nfct-helper-%s", helpname) <=
 0) {
>>                                 err =3D -EOPNOTSUPP;
>>                                 goto err_ct;
>>                         }
>> +                       rcu_read_lock();
>>                         helper =3D __nf_conntrack_helper_find(helpname, =
u3,
>>                                                             nf_ct_proton=
um(ct));
>>                         if (helper) {
>>                                 err =3D -EAGAIN;
>> -                               goto err_ct;
>> +                               goto err_rcu;
>>                         }
>> +                       rcu_read_unlock();
>>  #endif
>>                         err =3D -EOPNOTSUPP;
>>                         goto err_ct;
>> @@ -3159,11 +3163,13 @@ static int ctnetlink_del_expect(struct net *net,=
 struct sock *ctnl,
>>         exp =3D ctnetlink_alloc_expect(cda, ct, helper, &tuple, &mask);
>>         if (IS_ERR(exp)) {
>>                 err =3D PTR_ERR(exp);
>> -               goto err_ct;
>> +               goto err_rcu;
>>         }
>>
>>         err =3D nf_ct_expect_related_report(exp, portid, report);
>>         nf_ct_expect_put(exp);
>> +err_rcu:
>> +       rcu_read_unlock();
>>  err_ct:
>>         nf_ct_put(ct);
>>         return err;
>> --
>> 1.9.1
>>
>>
>
> This patch covers part fix of the another patch =E2=80=9CFix possible pan=
ic
> caused by invoking expectfn unloaded=E2=80=9D whose link is
> https://patchwork.ozlabs.org/patch/738566/ about RCU lock.
>
> Because the current patch also fixes the use-after-free helper issue,
> so I think it is better to commit the two patches.
> The first is current one, it fixes the use-after-free bug in
> ctnetlink_create_expect.
> The second is used to fixes the expectfn issue that we need to remove
> all expectations who reference the expectfn when unload the module.
>
> I am thinking about that if there is one better solution than my
> original patch.

I mean the second patch, not this one.
I am thinking about how to remove all expectation with one common
function for helper and expectfn.

I think this patch which fixes the use-after-free should be committed
as one single patch.

Regards
Feng

>
> Regards
> Feng
