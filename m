From: Laszlo Valko <valko@linux.karinthy.hu>
Subject: Re: Comments about IPT_ALIGN
Date: Mon, 27 Jan 2003 01:43:04 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030127014304.A10076@linux.karinthy.hu>
References: <3E335CB1.9070101@hipac.org> <20030126120159.A3045@linux.karinthy.hu> <3E33C665.9080106@fugmann.dhs.org> <20030126152227.A6811@linux.karinthy.hu> <3E342355.1030707@hipac.org> <20030126204358.B9418@linux.karinthy.hu> <3E346A9A.5020305@hipac.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Anders Fugmann <afu@fugmann.dhs.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Heinz <creatix@hipac.org>
Content-Disposition: inline
In-Reply-To: <3E346A9A.5020305@hipac.org>; from creatix@hipac.org on Mon, Jan 27, 2003 at 12:09:14AM +0100
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Thomas!

On Mon, Jan 27, 2003 at 12:09:14AM +0100, Thomas Heinz wrote:
> > The problem is that you _cannot_ determine from an x-bit userspace compiler
> > what alignment restrictions do exist on a y-bit kernelspace compiler. Since
> > they are two distinct compilers.
> > That's the fundamental flaw in __alignof__/IPT_ALIGN-type "hacking".
> 
> Hm, but we agree that the alignment of types of fixed width is the
> same even if x != y, e.g. __u64 is 8 byte aligned in sparc64 user and
> kernel space. The problem of stacking structs with different alignment

On sparc, it happens to be the same. I'm not sure how much pure luck
or intention this is. However, on x86, __u64 is definitely 4 byte aligned,
and I would expect x86-64 to do it differently (8 byte alignment).
This might even be a function of using different compiler options...

> requirements next to each other can be solved by aligning the structures
> according to what you call "strictest alignment on this platform"
> which IMO can be expressed by:
>    struct foo {[...]}__attribute__((aligned(__alignof__(u_int64_t))));

I think the "strictest alignment on this platform" should not come
from the compiler. It should be defined in some kernel header under
linux/include/asm-*.

Regards,
Laszlo

> Thomas
> 
