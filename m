From: Thomas Heinz <creatix@hipac.org>
Subject: Re: Comments about IPT_ALIGN
Date: Mon, 27 Jan 2003 11:33:55 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E350B13.8010502@hipac.org>
References: <3E335CB1.9070101@hipac.org> <20030126120159.A3045@linux.karinthy.hu> <3E33C665.9080106@fugmann.dhs.org> <20030126152227.A6811@linux.karinthy.hu> <3E342355.1030707@hipac.org> <20030126204358.B9418@linux.karinthy.hu> <3E346A9A.5020305@hipac.org> <20030127014304.A10076@linux.karinthy.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Anders Fugmann <afu@fugmann.dhs.org>,
 netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Laszlo Valko <valko@linux.karinthy.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Laszlo

You wrote:
> On sparc, it happens to be the same. I'm not sure how much pure luck
> or intention this is.

Good point. Maybe someone else can enlighten us.

> This might even be a function of using different compiler options...

Ok. If we have to deal with user and kernel space having different
alignment requirements for types of the same bit width but endianness
can be assumed to stay (at least for solution 1)) the same we have
(at least) two options:

1) Define a set of types with fixed bit width and fixed alignment
    requirements for each architecture which must also be made
    available in userspace (which implies that different type
    primitives might be used). The kernel-user structs may only use
    these types as basic types.

2) Define the kernel-user communication in terms of a network protocol
    (anyway, I guess this will be the case if netfilter communication is
    converted to netlink).

> I think the "strictest alignment on this platform" should not come
> from the compiler. It should be defined in some kernel header under
> linux/include/asm-*.

If one cannot make the necessary assumptions this is of course the only
way to define it properly.


Regards,

Thomas
