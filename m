From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: raw patch = kernel panic :(
Date: Tue, 7 Oct 2003 12:12:12 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0310071154220.17604-100000@blackhole.kfki.hu>
References: <20031006142214.GM5758@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031006142214.GM5758@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 6 Oct 2003, Harald Welte wrote:

> > Harald, I added the ported nf-log patch to the 2.5 p-o-m tree as
> > pending. But what to do with the port of the raw patch, which is ready?
> > Shall we introduce the userspace tree under patch-o-matic_2.5/?
>
> No.  We just commit the userspace changes to the stock iptables package.

OK. I added the patch as patch-o-matic_2.5/pending/71_raw.patch

> The changes are:
> - add support for the raw table to libipt_conntrack.  This needs
>   IPT_CONNTRACK_STATE_UNTRACKED defined.  It has an (ugly) section to
>   libipt_conntrack.c to accomodate the fact that we might not have a
>   patched kernel
> - add support to libipt_state. The same for IPT_STATE_UNTRACKED
> - add support for the raw table to libi4tc.c.  This has no compatibility
>   implications.

These are all covered by the patch-o-matic/userspace/raw.patch.userspace
part.

> So I don't really see the need for raw.patch having a userspace part at
> all.
>
> Did I miss something?

No, then there's no problem. I did not think of simply releasing a new
iptables snapshot.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
