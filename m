From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf 1/3] netfilter: conntrack: fix race between
 nf_conntrack proc read and hash resize
Date: Sat, 2 Jul 2016 19:46:12 +0200
Message-ID: <20160702174612.GD24701@breakpoint.cc>
References: <1467457167-5363-1-git-send-email-zlpnobody@163.com>
 <1467457167-5363-2-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53108 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254AbcGBRqh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Jul 2016 13:46:37 -0400
Content-Disposition: inline
In-Reply-To: <1467457167-5363-2-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
>=20
> When we do "cat /proc/net/nf_conntrack", and meanwhile resize the con=
ntrack
> hash table via /sys/module/nf_conntrack/parameters/hashsize, race wil=
l
> happen, because reader can observe a newly allocated hash but the old=
 size
> (or vice versa). So oops will happen like follows=EF=BC=9A
>=20
>   BUG: unable to handle kernel NULL pointer dereference at 0000000000=
000017
>   IP: [<ffffffffa0418e21>] seq_print_acct+0x11/0x50 [nf_conntrack]
>   Call Trace:
>   [<ffffffffa0412f4e>] ? ct_seq_show+0x14e/0x340 [nf_conntrack]
>   [<ffffffff81261a1c>] seq_read+0x2cc/0x390
>   [<ffffffff812a8d62>] proc_reg_read+0x42/0x70
>   [<ffffffff8123bee7>] __vfs_read+0x37/0x130
>   [<ffffffff81347980>] ? security_file_permission+0xa0/0xc0
>   [<ffffffff8123cf75>] vfs_read+0x95/0x140
>   [<ffffffff8123e475>] SyS_read+0x55/0xc0
>   [<ffffffff817c2572>] entry_SYSCALL_64_fastpath+0x1a/0xa4
>=20
> It is very easy to reproduce this kernel crash.
> 1. open one shell and input the following cmds:
>   while : ; do
>     echo $RANDOM > hashsize
>   done
> 2. open more shells and input the following cmds:
>   while : ; do
>     cat /proc/net/nf_conntrack
>   done
> 3. just wait a monent, oops will happen soon.

Good catch, but ...

> diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/=
netfilter/nf_conntrack_core.h
> index 3e2f332..4f6453a 100644
> --- a/include/net/netfilter/nf_conntrack_core.h
> +++ b/include/net/netfilter/nf_conntrack_core.h
> @@ -82,6 +82,7 @@ print_tuple(struct seq_file *s, const struct nf_con=
ntrack_tuple *tuple,
>  #define CONNTRACK_LOCKS 1024
> =20
>  extern struct hlist_nulls_head *nf_conntrack_hash;
> +extern seqcount_t nf_conntrack_generation;

instead of this and the proliferation of this:

> +	do {
> +		sequence =3D read_seqcount_begin(&nf_conntrack_generation);
> +		st->htable_size =3D nf_conntrack_htable_size;
> +		st->hash =3D nf_conntrack_hash;
> +	} while (read_seqcount_retry(&nf_conntrack_generation, sequence));
> +
>  	return ct_get_idx(seq, *pos);
>  }

I think it might be better to do something like

/* must be called with rcu read lock held */
unsigned int nf_conntrack_get_ht(struct hlist_nulls_head *h,
			         unsigned int *buckets)
{
	do {
		s =3D read_seq ...
		size =3D nf_conntrack_htable_size;
		ptr =3D nf_conntrack_hash;
	} while ...

	*h =3D ptr;
	*buckets =3D size;

	return s;
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
