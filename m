From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: New target - how to publish?
Date: Tue, 26 Aug 2003 12:31:45 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0308261212330.5081@dns.toxicfilms.tv>
References: <001501c36b98$ad6452a0$0a02a8c0@apiscomp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tomasz Krzyzaniak <apisek@czubki.za.net>
In-Reply-To: <001501c36b98$ad6452a0$0a02a8c0@apiscomp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> Hi!
>
> I wrote brand new target, but i don't know how to publish it and add it to
> iptables, just to be avaiable to everyone. Any sugestions?
Get the latest iptables source and patch-o-matic source.
Add your own libipt_BRANDEWTARGET.c to userspace/extensions
Add your own .BRANDNEWTARGET-test to userspace/extensions
Prepare a set of files for patch-o-matic:
BRANDNEW.patch
BRANDNEW.patch.config.in
BRANDNEW.patch.configure.help
BRANDNEW.patch.help
BRANDNEW.patch.makefile

Put them depending on their character to appropriate directory like: base,
extra, ...

For more information read the patch-o-matic/NEWPATCHES file.

Test your version of patch-o-matic, recompile iptables and re-check if
your TARGET works.

And then create a patch against an original netfilter tree like so:
# diff -Nru netfilter.orig netfilter > BRANDNEW_TARGET.diff

Recheck that diff, and send it off to netfilter-devel for inclusion to
CVS. This way it'll be possible for CVS and patch-o-matic users to check
that patch.

Regards,
Maciej
