From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: raw patch = kernel panic :(
Date: Mon, 6 Oct 2003 12:44:17 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0310061238480.15175-100000@blackhole.kfki.hu>
References: <3F8045B3.6000607@wp.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>, <laforge@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: c0g <c0g@wp.pl>
In-Reply-To: <3F8045B3.6000607@wp.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 5 Oct 2003, c0g wrote:

> I applied raw-patch from CVS patch-o-matic (20031003), and it appears
> that loading rule in PREROUTING chain of table raw causes kernel panic.

Yes, that was due to a stupid bug in the NOTRACK target. I have applied
the fixed patch in p-o-m. Sorry for the previous buggy release.

Harald, I added the ported nf-log patch to the 2.5 p-o-m tree as
pending. But what to do with the port of the raw patch, which is ready?
Shall we introduce the userspace tree under patch-o-matic_2.5/?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
