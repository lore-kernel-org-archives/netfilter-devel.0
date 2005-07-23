From: "Gilles Espinasse" <g.esp@free.fr>
Subject: nf-log patch fail to apply on 2.4.31 : solution
Date: Sat, 23 Jul 2005 12:10:28 +0200
Message-ID: <024201c58f6e$c09ebc10$f9b5a8c0@PII350>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

I try with pach-o-matic-20050716 and the last one available 20050722 on a
2.4.31 kernel without any other patches.

When used with
 ./runme --kernel-path=../linux-2.4.31 --iptables-path=../iptables-1.2.11/
pending
- everything until nf-log apply without problem
- with nf-log, test work but patch fail related to netfilter_logging.h

> The functionality relies on the available "backend" logging
> modules (ipt_LOG or ipt_ULOG). At least one of the logging
> modules must be loaded in, otherwise no log will be generated.
> If both modules are available in the kernel, then the firstly
> registered (loaded) will handle the logging.
> -----------------------------------------------------------------
> Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?] t
> Patch nf-log applies cleanly
> -----------------------------------------------------------------
> Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?] y
> ERROR (1 rejects out of 23 hunks)
>
manually applying the patch inside linux directory work
patch -Np1 < ../patch-o-matic-ng-20050716/patchlets/nf-log/linux-2.4.patch

Reason of failure is because netfilter_logging.h is present as a file under
patchlets/nf-log/include/linux-2.4/netfilter_logging.h and inside
linux-2.4.patch
Remove one on the 2 occurences and it work.
I remove patchlets/nf-log/linux-2.4/include/linux/netfilter_logging.h
because it was the easiest for me.

Next ownercmd (now include in pending but not in my old 20040621 version)
fail to apply, I remove it too

Gilles
