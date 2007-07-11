From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Patch for geoip to make it work with Linux kernel 2.6.22.x
Date: Wed, 11 Jul 2007 19:39:26 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707111938480.11053@fbirervta.pbzchgretzou.qr>
References: <twig.1177771162.67234@bugmachine.ca>
	<006801c7c309$2b8532a0$010210ac@BJERKESET.COM>
	<Pine.LNX.4.64.0707101839320.11053@fbirervta.pbzchgretzou.qr>
	<469415BF.8080805@imperialnet.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: patric <pakar@imperialnet.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <469415BF.8080805@imperialnet.org>
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


On Jul 11 2007 01:26, patric wrote:
>
> Just wanted to repost that there is a userspace daemon for this too..
>
> http://bladerunner.mine.nu/CJ/
>
> So if there is a bug in the code only the daemon fails and not the entire
> kernel.. =)
>
> It also eliminates the issues with kernel-revision incompatibility and should
> make  it easier for people to setup.

As far as I know you can only have one NFQUEUE userspace program at a time.

> Have not really had any time lately to
> work anything on this, but current release seems to be stable and has a current
> uptime of around a month (my last reboot of that system).
>
>
> Just don't laugh to much when reading the code... LOTS of really ugly code, but
> it works..  :)
>

	Jan
-- 
