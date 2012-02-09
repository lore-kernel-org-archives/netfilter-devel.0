From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: BUG nf_conntrack_ffff880863c50000: Objects remaining on
 kmem_cache_close()
Date: Thu, 9 Feb 2012 16:57:53 +0100
Message-ID: <20120209155753.GB5951@1984>
References: <4F328A81.4050607@univ-nantes.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jean-Philippe Menil <jean-philippe.menil@univ-nantes.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47145 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab2BIP57 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Feb 2012 10:57:59 -0500
Content-Disposition: inline
In-Reply-To: <4F328A81.4050607@univ-nantes.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 08, 2012 at 03:45:21PM +0100, Jean-Philippe Menil wrote:
> Hi,
>=20
> I'm seeing bug in a host with a 3.2.1 kernel.
> This host is running both kvm and lxc guest.
> It seems that it happened just after the restart of a lxc guest.
>=20
> However, it doesn't seem to affect any guest.
>=20
> I was just wondering if this was problematic, and if so, what should
> I do to debug this further.

Could you provide more information on your setup? Is it using
conntrackd or anything you think it can be relevant to this bug.

It can make it easier for us to know what's wrong with this.

> Regards.
>=20
> --=20
> Jean-Philippe Menil - P=F4le r=E9seau Service IRTS
> DSI Universit=E9 de Nantes
> jean-philippe.menil@univ-nantes.fr
> Tel : 02.53.48.49.27 - Fax : 02.53.48.49.09
>=20

> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28512=
5] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28517=
3] BUG nf_conntrack_ffff880863c50000: Objects remaining on kmem_cache_c=
lose()
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28522=
3] --------------------------------------------------------------------=
---------
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28522=
4]=20
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28529=
1] INFO: Slab 0xffffea000fecf280 objects=3D26 used=3D1 fp=3D0xffff8803f=
b3ca4e0 flags=3D0x200000000004080
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28533=
9] Pid: 5, comm: kworker/u:0 Not tainted 3.2.1-dsiun-120113 #55
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28536=
6] Call Trace:
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28539=
3]  [<ffffffff811194c0>] ? slab_err+0x80/0x90
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28541=
9]  [<ffffffff8111c6c9>] ? kmem_cache_destroy+0x169/0x3b0
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28544=
9]  [<ffffffff8111c6ec>] ? kmem_cache_destroy+0x18c/0x3b0
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28548=
7]  [<ffffffffa049f753>] ? nf_conntrack_cleanup+0xd3/0x130 [nf_conntrac=
k]
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28554=
5]  [<ffffffff812f7b48>] ? ops_exit_list.isra.1+0x38/0x70
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28557=
4]  [<ffffffff812f8260>] ? net_drop_ns+0x40/0x40
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28560=
0]  [<ffffffff812f8360>] ? cleanup_net+0x100/0x1a0
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28564=
3]  [<ffffffff810635c6>] ? process_one_work+0x106/0x460
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28567=
0]  [<ffffffff8106486c>] ? worker_thread+0x14c/0x330
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28569=
7]  [<ffffffff81064720>] ? manage_workers.isra.30+0x210/0x210
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28573=
6]  [<ffffffff8106905e>] ? kthread+0x7e/0x90
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28576=
3]  [<ffffffff813aee34>] ? kernel_thread_helper+0x4/0x10
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28579=
0]  [<ffffffff81068fe0>] ? kthread_worker_fn+0x190/0x190
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28581=
7]  [<ffffffff813aee30>] ? gs_change+0x13/0x13
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28584=
3] INFO: Object 0xffff8803fb3ca000 @offset=3D0
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28586=
9] SLUB nf_conntrack_ffff880863c50000: kmem_cache_destroy called for ca=
che that still has objects.
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28591=
6] Pid: 5, comm: kworker/u:0 Not tainted 3.2.1-dsiun-120113 #55
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28594=
3] Call Trace:
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28596=
4]  [<ffffffff8111c7a8>] ? kmem_cache_destroy+0x248/0x3b0
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28599=
1]  [<ffffffff8111c863>] ? kmem_cache_destroy+0x303/0x3b0
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28602=
0]  [<ffffffffa049f753>] ? nf_conntrack_cleanup+0xd3/0x130 [nf_conntrac=
k]
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28606=
4]  [<ffffffff812f7b48>] ? ops_exit_list.isra.1+0x38/0x70
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28609=
2]  [<ffffffff812f8260>] ? net_drop_ns+0x40/0x40
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28611=
7]  [<ffffffff812f8360>] ? cleanup_net+0x100/0x1a0
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28614=
4]  [<ffffffff810635c6>] ? process_one_work+0x106/0x460
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28622=
7]  [<ffffffff8106486c>] ? worker_thread+0x14c/0x330
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28625=
3]  [<ffffffff81064720>] ? manage_workers.isra.30+0x210/0x210
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28628=
1]  [<ffffffff8106905e>] ? kthread+0x7e/0x90
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28630=
6]  [<ffffffff813aee34>] ? kernel_thread_helper+0x4/0x10
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28633=
3]  [<ffffffff81068fe0>] ? kthread_worker_fn+0x190/0x190
> Feb  8 13:31:38 ayrshire.u06.univ-nantes.prive kernel: [1133137.28636=
0]  [<ffffffff813aee30>] ? gs_change+0x13/0x13
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
