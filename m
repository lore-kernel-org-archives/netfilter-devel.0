From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] time patch update, and possible bug in ./runme script
Date: Wed, 5 May 2004 12:20:36 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405051211310.29939-100000@blackhole.kfki.hu>
References: <200405042331.05709.fabrice@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Fabrice MARIE <fabrice@netfilter.org>
In-Reply-To: <200405042331.05709.fabrice@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Fabrice,

On Tue, 4 May 2004, Fabrice MARIE wrote:

> Please find attached a patch to the time match to add support for date
> matching (Idea from Fabien COELHO, code rewriten to fit into the time
> match). I modified the usage of the match so that it is still backward
> compatible, and yet allow for all the parameters to be facultative as
> requested for a long time by many people.

Patch is applied, thank you.

> PS: Jozsef, it seems that there is a problem with the current runme
> script. Although the patch apply fine, runme doesn't apply the kernel
> configure help stuff anymore.  I tried to apply both the time patch
> and the TTL patch on a 2.6.x kernel, and then checked the help message
> while configuring the kernel but the help message is empty for both.
> In the file: linux-2.6.5-rc3-bk3/net/ipv4/netfilter/Kconfig I have
> this at the end. (The help stanza is empty)

That is partly a misunderstanding and partly a bug :-).
The bug is that runme added the errorneous 'help' to Kconfig - this is
fixed in cvs. The misunderstanding is that you have to add the help text
to Kconfig.ladd, which will then be added by runme to the kernel source.

We >could< figure out the help text from Configure.help.ladd, but that's
errorneous (there can be multiple help entries in a single ladd file),
hard to implement (we really support multiple branches and multiple
versions in every branch) and ridiculous.

I'm writing a script which fills Kconfig.ladd files with help text from
Configure.help.ladd files and manually check the result in cvs. Can't
finish today, expect fixed Kconfig.ladd files tomorrow.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
