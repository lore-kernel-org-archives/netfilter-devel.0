From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: conntrack oops
Date: Mon, 2 Aug 2004 14:35:40 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0408021431280.7180-100000@blackhole.kfki.hu>
References: <20040802073601.GV1703@thunderchild.debian.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Gergely Madarasz <gorgo@broadband.hu>
In-Reply-To: <20040802073601.GV1703@thunderchild.debian.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2 Aug 2004, Gergely Madarasz wrote:

> On Sat, Jul 24, 2004 at 11:39:55AM +0200, Gergely Madarasz wrote:
> > Code;  c02416d5 <init_conntrack+30d/3dc>
> > 00000000 <_EIP>:
> > Code;  c02416d5 <init_conntrack+30d/3dc>   <=====
> >    0:   83 78 18 00               cmpl   $0x0,0x18(%eax)   <=====
> > Code;  c02416d9 <init_conntrack+311/3dc>
> >    4:   74 15                     je     1b <_EIP+0x1b>
> > Code;  c02416db <init_conntrack+313/3dc>
> >    6:   8d 43 2c                  lea    0x2c(%ebx),%eax
> > Code;  c02416de <init_conntrack+316/3dc>
> >    9:   50                        push   %eax
> > Code;  c02416df <init_conntrack+317/3dc>
> >    a:   e8 1c ea ed ff            call   ffedea2b <_EIP+0xffedea2b>
> > Code;  c02416e4 <init_conntrack+31c/3dc>
> >    f:   89 c2                     mov    %eax,%edx
> > Code;  c02416e6 <init_conntrack+31e/3dc>
> >   11:   83 c4 04                  add    $0x4,%esp
>
> It seems I didn't give enough information about this bug... :(
>
> I guess there is a race condition somewhere, the oops occurs at:
>
>         if (expected
>             && expected->expectant->helper->timeout
>             && ! del_timer(&expected->timeout))
>                 expected = NULL;

There are several important bugfixes (04_linux-2.4.26-helper_reassign
and 05_linux-2.4.26-orphaned_expect and similar for 2.6.6) in
patch-o-matic-ng/updates. Please apply them so that we can make sure what
you reported is a solved problem or not.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
