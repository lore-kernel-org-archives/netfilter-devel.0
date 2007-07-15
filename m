From: Sven Wegener <sven.wegener@stealer.net>
Subject: Re: [PATCH] Change default KERNEL_DIR location and add KBUILD_OUTPUT
Date: Sun, 15 Jul 2007 17:31:45 +0200
Message-ID: <20070715153145.GA24365@titan.stealer.net>
References: <20070714201513.GA9970@titan.stealer.net>
	<469A3070.7030506@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <469A3070.7030506@trash.net>
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

On Sun, Jul 15, 2007 at 04:34:24PM +0200, Patrick McHardy wrote:
> Sven Wegener wrote:
> > Setting KERNEL_DIR to the build symlink in /lib/modules is wrong. The
> > build symlink points to the location of generated object files and the
> > extension tests use KERNEL_DIR to check the availability of certain
> > source files.
> 
> Good point.
> 
> > The tests will fail, if build and source point to
> > different locations. Change KERNEL_DIR from build to source and
> > introduce KBUILD_OUTPUT for the build symink.
> 
> What do we need KBUILD_OUTPUT for? Just the source tree should be enough.

For current kernels, true. Older kernels (before 2006-04-26) and the
whole 2.6.16.y series have a bug where include/linux/netfilter_ipv4.h
includes linux/config.h which includes linux/autoconf.h which is placed
into KBUILD_OUTPUT. Just changing KERNEL_DIR from build to source should
be enough for recent kernels. For older kernels building the iptables
package will fail with "linux/autoconf.h: No such file or directory"
unless we add the KBUILD_OUTPUT bit. That's why I added it. Do we want
to have this workaround here?

Sven
