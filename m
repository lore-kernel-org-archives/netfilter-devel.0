From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Deadlocks
Date: Thu, 10 Jun 2004 10:07:16 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406101002170.1962-100000@blackhole.kfki.hu>
References: <20040609180909.GA11445@linuxace.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20040609180909.GA11445@linuxace.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 9 Jun 2004, Phil Oester wrote:

> For the past 3 months I've been experiencing deadlocks on some heavily
> used gateway/firewall boxes which started after upgrading from 2.4.20.
>
> I can confirm that moving back to 2.4.20 stops the hangs, moving to 2.4.21
> (or any kernel after that) makes them return.  I am in the process of testing
> out each individual 2.4.21-pre to find out where exactly the problem is.
>
> In the interim, I've collected some SysRq output which may help in the
> analysis.  Below are two separate lockups on a 2.6.6 kernel.  Anyone have
> any bright ideas?

Could you try out the 05_linux-2.4.26-orphaned_expect.patch or
05_linux-2.6.6-orphaned_expect.patch depending on the kernel
from pom-ng/updates? I think that is the fix for your lockups.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
