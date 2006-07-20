From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Use gcc to build shared objects
Date: Thu, 20 Jul 2006 18:31:09 +0200
Message-ID: <44BFAFCD.40805@trash.net>
References: <20060715192508.GA14699@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20060715192508.GA14699@linuxace.com>
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

Phil Oester wrote:
> As suggested by Dmitry Levin and included in Fedora Core releases,
> use gcc instead of ld to link shared objects.  Fedora rpm notes
> refer to this fixing a plugin problem, but does not offer specifics.
> But in any event, 'gcc -dumpspecs' does show gcc will pass a number
> of parameters which in theory it thinks are better.
> 
> Compile tested both with and without NO_SHARED_LIBS.
> 
> Closes bug #454.

Applied, thanks.
