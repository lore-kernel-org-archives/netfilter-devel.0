From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] problem with 'raw' patch and REJECT target
Date: Fri, 9 Jan 2004 10:40:52 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0401091015240.21171-100000@blackhole.kfki.hu>
References: <000d01c3d60c$596b1f10$3200000a@gatis>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Gatis Peisenieks <gatis@mt.lv>
In-Reply-To: <000d01c3d60c$596b1f10$3200000a@gatis>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Gatis,

On Thu, 8 Jan 2004, Gatis Peisenieks wrote:

> here is a patch that fixes (?) a bug in 'raw' table. The bug can be
> replicated by using raw table with one NOTRACK rule that matches everything
> and a filter rule (in my case in INPUT chain) that has  REJECT target. First
> ICMP/TCP packet that matches the REJECT rule make the kernel crash with NULL
> pointer dereference.

Your analysis and patch is correct. Thank you very much, I'll add the
fixed raw patch to cvs.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
