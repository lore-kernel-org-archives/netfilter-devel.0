From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Change default KERNEL_DIR location and add KBUILD_OUTPUT
Date: Sun, 15 Jul 2007 16:34:24 +0200
Message-ID: <469A3070.7030506@trash.net>
References: <20070714201513.GA9970@titan.stealer.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Sven Wegener <sven.wegener@stealer.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070714201513.GA9970@titan.stealer.net>
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

Sven Wegener wrote:
> Setting KERNEL_DIR to the build symlink in /lib/modules is wrong. The
> build symlink points to the location of generated object files and the
> extension tests use KERNEL_DIR to check the availability of certain
> source files.

Good point.

> The tests will fail, if build and source point to
> different locations. Change KERNEL_DIR from build to source and
> introduce KBUILD_OUTPUT for the build symink.


What do we need KBUILD_OUTPUT for? Just the source tree should be enough.
