From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH]: bug with --dst-range in libipt_iprange.c
Date: Mon, 12 Jul 2004 09:19:28 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0407120918370.24191-100000@blackhole.kfki.hu>
References: <32886.192.168.1.19.1089594334.squirrel@192.168.1.19>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nicolas Bouliane <nib@cookinglinux.org>
In-Reply-To: <32886.192.168.1.19.1089594334.squirrel@192.168.1.19>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 11 Jul 2004, Nicolas Bouliane wrote:

> When using --dst-range twice, which is supposed to return an error,
> the second given ip range is overwriting the previously set ip range.
>
> The --src-range option is working perfectly; we can't use it twice.
> But --dst-range just doesn't because the flag is always reset to 1.

Thank you the bug report and the fix, the patch is applied in cvs.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
