From: Stephane Chazelas <stephane@artesyncp.com>
Subject: Re: [bug+patch] SCTP and chunk types over 0x1f
Date: Mon, 25 Jun 2007 16:07:22 +0100
Message-ID: <20070625150722.GY20467@artesyncp.com>
References: <20070622151940.GA20467@artesyncp.com> <467FC5CB.9080608@trash.net>
	<20070625135040.GV20467@artesyncp.com> <467FCA13.5050401@trash.net>
	<20070625140839.GW20467@artesyncp.com>
	<20070625141506.GX20467@artesyncp.com> <467FD469.8090001@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <467FD469.8090001@trash.net>
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

On Mon, Jun 25, 2007 at 04:42:49PM +0200, Patrick McHardy wrote:
> Stephane Chazelas wrote:
> > On Mon, Jun 25, 2007 at 03:08:39PM +0100, Stephane Chazelas wrote:
> > 
> >>>Does it stay completely compatible (modulo fixed bugs) then?
> >>
> >>AFAICT, yes (though I've not tested it). I don't know if the
> >>kernel needs to be rebuilt for the bug to be fixed (that is, I
> >>don't know whether in the kernel code there are some calls to
> >>the SCTP_CHUNKMAP_IS_ALL_SET and cie macros with non-array
> >>arguments, I don't think there are).
> > 
> > [...]
> > 
> > actually yes, the kernel is affected. See "return
> > SCTP_CHUNKMAP_IS_CLEAR(chunkmap)" for instance in match_packet()
> > in net/netfilter/xt_sctp.c, chunkmap is u_int32_t*, so
> > ARRAY_SIZE(chunkmap) will return
> > sizeof(u_int32_t*)/sizeof(u_int32_t) that is probably 1 or 2
> > instead of 64 or 8.
> > 
> > The fixed iptable should work with either a fixed or non-fixed
> > kernel. However, with a non-fixed kernel, it will not fix the
> > bug completely.
> 
> 
> Thats fine, bugs in the kernel need a new kernel of course.
> The important thing is that userspace compatibility of old
> binaries is not affected. So the kernel just needs the
> new xt_sctp file?

Well, no, the new header files to match the ones in iptable, so
include/linux/netfilter/xt_sctp.h and
include/linux/netfilter_ipv4/ipt_sctp.h

(replace the ELEMCOUNT(...) with (256/32))

Or you could fix xt_sctp.c, but then, you'd have a discrepancy
between the header file in the kernel and the header file in
iptables.

Or else, you could fix iptables without changing the header
files maybe by doing some sort of dodgy array type casting (I'm
not sure how you'd do that though).

Cheers,
Stephane
