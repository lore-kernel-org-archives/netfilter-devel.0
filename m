From: Shan Wei <shanwei@cn.fujitsu.com>
Subject: Re: [PATCH] netfilter:ipset: fix the compile warning in ip_set_create
Date: Fri, 04 Mar 2011 19:27:05 +0800
Message-ID: <4D70CC89.5020604@cn.fujitsu.com>
References: <4D70960B.2040209@cn.fujitsu.com> <alpine.DEB.2.00.1103040956050.29227@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53940 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab1CDL3j convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:29:39 -0500
In-Reply-To: <alpine.DEB.2.00.1103040956050.29227@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote, at 03/04/2011 05:00 PM:
> On Fri, 4 Mar 2011, Shan Wei wrote:
>=20
>> net/netfilter/ipset/ip_set_core.c:615: warning: ?clash? may be used =
uninitialized in this function
>>
>> Signed-off-by: shanw <shanw@shanw-desktop.(none)>
>> ---
>>  net/netfilter/ipset/ip_set_core.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset=
/ip_set_core.c
>> index 8b1a54c..618a615 100644
>> --- a/net/netfilter/ipset/ip_set_core.c
>> +++ b/net/netfilter/ipset/ip_set_core.c
>> @@ -612,7 +612,7 @@ ip_set_create(struct sock *ctnl, struct sk_buff =
*skb,
>>  	      const struct nlmsghdr *nlh,
>>  	      const struct nlattr * const attr[])
>>  {
>> -	struct ip_set *set, *clash;
>> +	struct ip_set *set, *clash =3D NULL;
>>  	ip_set_id_t index =3D IPSET_INVALID_ID;
>>  	struct nlattr *tb[IPSET_ATTR_CREATE_MAX+1] =3D {};
>>  	const char *name, *typename;
>> --=20
>> 1.6.3.3
>=20
> Thanks, I applied your patch in my tree.
>=20
> Patrick, please apply it too.
>=20
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
>=20

Thanks for your review.
Bad sob in first patch, fix it in new one.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[PATCH v2] netfilter:ipset: fix the compile warning in ip_set_create

net/netfilter/ipset/ip_set_core.c:615: warning: =E2=80=98clash=E2=80=99=
 may be used uninitialized in this function

Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip=
_set_core.c
index 8b1a54c..618a615 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -612,7 +612,7 @@ ip_set_create(struct sock *ctnl, struct sk_buff *sk=
b,
 	      const struct nlmsghdr *nlh,
 	      const struct nlattr * const attr[])
 {
-	struct ip_set *set, *clash;
+	struct ip_set *set, *clash =3D NULL;
 	ip_set_id_t index =3D IPSET_INVALID_ID;
 	struct nlattr *tb[IPSET_ATTR_CREATE_MAX+1] =3D {};
 	const char *name, *typename;
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
