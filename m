From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Remote DoS vulnerability in Linux kernel 2.6.x (fwd)
Date: Thu, 1 Jul 2004 10:59:10 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0407011057350.29206-100000@blackhole.kfki.hu>
References: <Xine.LNX.4.44.0406301423320.32212-100000@thoron.boston.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>,
	Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: James Morris <jmorris@redhat.com>
In-Reply-To: <Xine.LNX.4.44.0406301423320.32212-100000@thoron.boston.redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Wed, 30 Jun 2004, James Morris wrote:

> ---------- Forwarded message ----------
> Date: Wed, 30 Jun 2004 12:57:17 +0200
> From: Adam Osuchowski <adwol@polsl.gliwice.pl>
> To: bugtraq@securityfocus.com
> Subject: Remote DoS vulnerability in Linux kernel 2.6.x
>
> 1. Overview
> -----------
>
> There is a remotely exploitable bug in all Linux kernel 2.6 series due to
> using incorrect variable type. Vulnerability is connected to netfilter
> subsystem and may cause DoS. It's disclosed only when using iptables with
> rules matching TCP options (i.e.  --tcp-option). There is no difference
> what action is taking up by matching rule.
>
> Vulnerability was detected on i386 architecture. The other ones weren't tested
> but it seems to be vulnerable too.

I have added the patch to the patch-o-matic-ng cvs, so one can apply it
easily using our repository.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
