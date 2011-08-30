From: Jean-Philippe Menil <jean-philippe.menil@univ-nantes.fr>
Subject: Re: kernel BUG at net/netfilter/ipset/ip_set_core.c:314
Date: Tue, 30 Aug 2011 16:14:39 +0200
Message-ID: <4E5CF04F.8070704@univ-nantes.fr>
References: <4E5CA623.9000402@univ-nantes.fr> <alpine.DEB.2.00.1108301556050.26239@blackhole.kfki.hu>
Reply-To: jean-philippe.menil@univ-nantes.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-tls1.univ-nantes.fr ([193.52.101.145]:36071 "EHLO
	smtp-tls.univ-nantes.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab1H3OOk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Aug 2011 10:14:40 -0400
In-Reply-To: <alpine.DEB.2.00.1108301556050.26239@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 30/08/2011 15:59, Jozsef Kadlecsik a =E9crit :
> Hi,
>
> On Tue, 30 Aug 2011, Jean-Philippe Menil wrote:
>
>> With the set bitmap ipmac, if i had one, two hundred ip,mac in a set=
; and do
>> an ipset list,
>> i get an:
>> ipset v6.8: Kernel error received: No buffer space available
>> followed by a kernel panic (trace attached).
> If possible, could you stress-test the case with the patch below appl=
ied?
>
> If there was a dumping error in the middle, the set-specific variable=
 was
> not zeroed out and thus the 'done' function of the dumping wrongly tr=
ied
> to release the already released reference of the set.
>
> diff --git a/kernel/net/netfilter/ipset/ip_set_core.c b/kernel/net/ne=
tfilter/ipset/ip_set_core.c
> index b5d380c..c3eabfd 100644
> --- a/kernel/net/netfilter/ipset/ip_set_core.c
> +++ b/kernel/net/netfilter/ipset/ip_set_core.c
> @@ -1148,6 +1148,7 @@ release_refcount:
>   	if (ret || !cb->args[2]) {
>   		pr_debug("release set %s\n", ip_set_list[index]->name);
>   		ip_set_put_byindex(index);
> +		cb->args[2] =3D 0;
>   	}
>   out:
>   	if (nlh) {
>
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : KFKI Research Institute for Particle and Nuclear Physics
>            H-1525 Budapest 114, POB. 49, Hungary
Hi,

It seems to do the trick.
I've no more panic adding two hundred ip,mac, except the error when=20
trying to list the set.

Thanks a lot.

Regards.

--=20
Jean-Philippe Menil - P=F4le r=E9seau Service IRTS
DSI Universit=E9 de Nantes
jean-philippe.menil@univ-nantes.fr
Tel : 02.53.48.49.27 - Fax : 02.53.48.49.09

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
