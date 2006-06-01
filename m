From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_conntrack_proto_sctp.c:(.text+0x2e660): undefined reference
 to `local_bh_disable'
Date: Thu, 01 Jun 2006 12:01:27 +0900 (JST)
Message-ID: <200606010301.k5131Tk1012237@toshiba.co.jp>
References: <200605311253.54503.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org,
	kaber@trash.net, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: toralf.foerster@gmx.de
In-Reply-To: <200605311253.54503.toralf.foerster@gmx.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


From: Toralf F=F6rster <toralf.foerster@gmx.de>
Date: Wed, 31 May 2006 12:53:51 +0200

> Compiling current kernel linux-2.6.17-rc5-git7 I got this error:
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> net/built-in.o: In function `sctp_print_conntrack':
> nf_conntrack_proto_sctp.c:(.text+0x2e660): undefined reference to `lo=
cal_bh_disable'
> net/built-in.o: In function `sctp_packet':
> nf_conntrack_proto_sctp.c:(.text+0x2e8c1): undefined reference to `lo=
cal_bh_disable'
> net/built-in.o: In function `ctnetlink_dump_table':
> nf_conntrack_netlink.c:(.text+0x2f710): undefined reference to `local=
_bh_disable'
> net/built-in.o: In function `ctnetlink_dump_table_w':
> nf_conntrack_netlink.c:(.text+0x2f840): undefined reference to `local=
_bh_disable'
> net/built-in.o: In function `ctnetlink_new_conntrack':
> nf_conntrack_netlink.c:(.text+0x307c9): undefined reference to `local=
_bh_disable'
> net/built-in.o:nf_conntrack_netlink.c:(.text+0x311cc): more undefined=
 references to `local_bh_disable' follow
> make: *** [.tmp_vmlinux1] Error 1
> =

> .config is attached.

Actually nf_conntrack_proto_sctp.c doesn't include spinlock.h.

But to compile them, I also needed to add interrupt.h to them.
I wonder why that is necessary. they don't call local_bh_{disable,enabl=
e}
directly but call {read, write}_lock_bh(). Then I think that spinlock.h=
 is
enough and spinlock_api_up.h should include interrupt.h.

Anyway, I attach a patch make them include spinlock.h and interrupt.h
like ip_conntrack_netlink.c.

-- Yasuyuki Kozakai
