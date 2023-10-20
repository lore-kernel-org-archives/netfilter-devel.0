Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E757CDB47E
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Oct 2023 09:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376614AbjJTJSb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Oct 2023 05:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376623AbjJTJSa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2023 05:18:30 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD61AD7B
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2023 02:18:19 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 6BC92CC02BE;
        Fri, 20 Oct 2023 11:18:18 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri, 20 Oct 2023 11:18:16 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 359E8CC010F;
        Fri, 20 Oct 2023 11:18:14 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id EA2CE3431A9; Fri, 20 Oct 2023 11:18:14 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id E8C313431A8;
        Fri, 20 Oct 2023 11:18:14 +0200 (CEST)
Date:   Fri, 20 Oct 2023 11:18:14 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Linkui Xiao <xiaolinkui@kylinos.cn>
cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: ipset: fix race condition between
 swap/destroy and kernel side add/del/test
In-Reply-To: <0fb13f84-821f-7131-e67e-d51e15153692@kylinos.cn>
Message-ID: <c221a55-ed44-3b2d-ad96-4f8b835745de@netfilter.org>
References: <20231019191937.3931271-1-kadlec@netfilter.org> <20231019191937.3931271-2-kadlec@netfilter.org> <0fb13f84-821f-7131-e67e-d51e15153692@kylinos.cn>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-2055255218-1697793494=:739764"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-2055255218-1697793494=:739764
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 20 Oct 2023, Linkui Xiao wrote:

> On 10/20/23 03:19, Jozsef Kadlecsik wrote:
> > Linkui Xiao reported that there's a race condition when ipset swap an=
d
> > destroy is
> > called, which can lead to crash in add/del/test element operations. S=
wap
> > then
> > destroy are usual operations to replace a set with another one in a
> > production
> > system. The issue can in some cases be reproduced with the script:
> >=20
> > ipset create hash_ip1 hash:net family inet hashsize 1024 maxelem 1048=
576
> > ipset add hash_ip1 172.20.0.0/16
> > ipset add hash_ip1 192.168.0.0/16
> > iptables -A INPUT -m set --match-set hash_ip1 src -j ACCEPT
> > while [ 1 ]
> > do
> > 	# ... Ongoing traffic...
> >          ipset create hash_ip2 hash:net family inet hashsize 1024 max=
elem
> > 1048576
> >          ipset add hash_ip2 172.20.0.0/16
> >          ipset swap hash_ip1 hash_ip2
> >          ipset destroy hash_ip2
> >          sleep 0.05
> > done
> >=20
> > In the race case the possible order of the operations are
> >=20
> > 	CPU0			CPU1
> > 	ip_set_test
> > 				ipset swap hash_ip1 hash_ip2
> > 				ipset destroy hash_ip2
> > 	hash_net_kadt
> >=20
> > Swap replaces hash_ip1 with hash_ip2 and then destroy removes hash_ip=
2 which
> > is the original hash_ip1. ip_set_test was called on hash_ip1 and beca=
use
> > destroy
> > removed it, hash_net_kadt crashes.
> >=20
> > The fix is to protect both the list of the sets and the set pointers =
in an
> > extended RCU
> > region and before calling destroy, wait to finish all started
> > rcu_read_lock().
> >=20
> > The first version of the patch was written by Linkui Xiao
> > <xiaolinkui@kylinos.cn>.
> >=20
> > Closes:
> > https://lore.kernel.org/all/69e7963b-e7f8-3ad0-210-7b86eebf7f78@netfi=
lter.org/
> > Reported by: Linkui Xiao <xiaolinkui@kylinos.cn>
> > Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
> > ---
> >   net/netfilter/ipset/ip_set_core.c | 28 +++++++++++++++++++++++-----
> >   1 file changed, 23 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/net/netfilter/ipset/ip_set_core.c
> > b/net/netfilter/ipset/ip_set_core.c
> > index e564b5174261..7eedd2825e0c 100644
> > --- a/net/netfilter/ipset/ip_set_core.c
> > +++ b/net/netfilter/ipset/ip_set_core.c
> > @@ -704,13 +704,18 @@ ip_set_rcu_get(struct net *net, ip_set_id_t ind=
ex)
> >   	struct ip_set_net *inst =3D ip_set_pernet(net);
> >     	rcu_read_lock();
> > -	/* ip_set_list itself needs to be protected */
> > +	/* ip_set_list and the set pointer need to be protected */
> >   	set =3D rcu_dereference(inst->ip_set_list)[index];
> > -	rcu_read_unlock();
> >     	return set;
> >   }
> >   +static inline void
> > +ip_set_rcu_put(struct ip_set *set __always_unused)
> > +{
> > +	rcu_read_unlock();
> > +}
> > +
> >   static inline void
> >   ip_set_lock(struct ip_set *set)
> >   {
> > @@ -736,8 +741,10 @@ ip_set_test(ip_set_id_t index, const struct sk_b=
uff
> > *skb,
> >   	pr_debug("set %s, index %u\n", set->name, index);
> >     	if (opt->dim < set->type->dimension ||
> > -	    !(opt->family =3D=3D set->family || set->family =3D=3D NFPROTO_=
UNSPEC))
> > +	    !(opt->family =3D=3D set->family || set->family =3D=3D NFPROTO_=
UNSPEC)) {
> > +		ip_set_rcu_put(set);
> >   		return 0;
> > +	}
> >     	ret =3D set->variant->kadt(set, skb, par, IPSET_TEST, opt);
> >   @@ -756,6 +763,7 @@ ip_set_test(ip_set_id_t index, const struct sk_=
buff
> > *skb,
> >   			ret =3D -ret;
> >   	}
> >   +	ip_set_rcu_put(set);
> >   	/* Convert error codes to nomatch */
> >   	return (ret < 0 ? 0 : ret);
> >   }
> > @@ -772,12 +780,15 @@ ip_set_add(ip_set_id_t index, const struct sk_b=
uff
> > *skb,
> >   	pr_debug("set %s, index %u\n", set->name, index);
> >     	if (opt->dim < set->type->dimension ||
> > -	    !(opt->family =3D=3D set->family || set->family =3D=3D NFPROTO_=
UNSPEC))
> > +	    !(opt->family =3D=3D set->family || set->family =3D=3D NFPROTO_=
UNSPEC)) {
> > +		ip_set_rcu_put(set);
> >   		return -IPSET_ERR_TYPE_MISMATCH;
> > +	}
> >     	ip_set_lock(set);
> >   	ret =3D set->variant->kadt(set, skb, par, IPSET_ADD, opt);
> >   	ip_set_unlock(set);
> > +	ip_set_rcu_put(set);
> >     	return ret;
> >   }
> > @@ -794,12 +805,15 @@ ip_set_del(ip_set_id_t index, const struct sk_b=
uff
> > *skb,
> >   	pr_debug("set %s, index %u\n", set->name, index);
> >     	if (opt->dim < set->type->dimension ||
> > -	    !(opt->family =3D=3D set->family || set->family =3D=3D NFPROTO_=
UNSPEC))
> > +	    !(opt->family =3D=3D set->family || set->family =3D=3D NFPROTO_=
UNSPEC)) {
> > +		ip_set_rcu_put(set);
> >   		return -IPSET_ERR_TYPE_MISMATCH;
> > +	}
> >     	ip_set_lock(set);
> >   	ret =3D set->variant->kadt(set, skb, par, IPSET_DEL, opt);
> >   	ip_set_unlock(set);
> > +	ip_set_rcu_put(set);
> >     	return ret;
> >   }
> > @@ -874,6 +888,7 @@ ip_set_name_byindex(struct net *net, ip_set_id_t =
index,
> > char *name)
> >   	read_lock_bh(&ip_set_ref_lock);
> >   	strscpy_pad(name, set->name, IPSET_MAXNAMELEN);
> >   	read_unlock_bh(&ip_set_ref_lock);
> > +	ip_set_rcu_put(set);
> >   }
> >   EXPORT_SYMBOL_GPL(ip_set_name_byindex);
> >   @@ -1188,6 +1203,9 @@ static int ip_set_destroy(struct sk_buff *skb=
, const
> > struct nfnl_info *info,
> >   	if (unlikely(protocol_min_failed(attr)))
> >   		return -IPSET_ERR_PROTOCOL;
> >   +	/* Make sure all readers of the old set pointers are completed. *=
/
> > +	synchronize_rcu();
> > +
> >   	/* Must wait for flush to be really finished in list:set */
> >   	rcu_barrier();
> >  =20
> This patch is valid in my case.But I have a question, if there are many=
=20
> concurrent ipsets. One ip_set_test was not completed, and another=20
> ip_set_test also came in, there are always some rcu_read_lock() without=
=20
> unlock. The ip_set_destroy will always wait to finish all started=20
> rcu_read_lock().=C2=A0 Is there a problem? Actually, ip_set_destroy sho=
uld=20
> only need to wait for the ipset (the one that was swapped) to finish=20
> ip_set_test. It is unnecessary to wait for other ipsets ongoing traffic=
.

synchronize_rcu() waits for already initiated rcu_read_lock() regions to=20
be completed with rcu_read_unlock(). If a parallel processing enters an=20
rcu_read_lock() protected area while synchronize_rcu() is working, it=20
won't wait for those to be completed as well. So it does exactly what we'=
d=20
like to achieve.

Somewhere we have to pay the price for excluding clashing operations.=20
ip_set_destroy() is the best place because we can destroy sets only which=
=20
are not used by ipset match/target/ematch and thus it does not affect=20
ongoing traffic at all.

Best regards,
Jozsef
--=20
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-2055255218-1697793494=:739764--
