From: Laszlo Valko <valko@linux.karinthy.hu>
Subject: Re: Comments about IPT_ALIGN
Date: Sun, 26 Jan 2003 15:22:27 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030126152227.A6811@linux.karinthy.hu>
References: <3E335CB1.9070101@hipac.org> <20030126120159.A3045@linux.karinthy.hu> <3E33C665.9080106@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Heinz <creatix@hipac.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Anders Fugmann <afu@fugmann.dhs.org>
Content-Disposition: inline
In-Reply-To: <3E33C665.9080106@fugmann.dhs.org>; from afu@fugmann.dhs.org on Sun, Jan 26, 2003 at 12:28:37PM +0100
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, Jan 26, 2003 at 12:28:37PM +0100, Anders Fugmann wrote:
> Does this not pose an interresting problem?
> What happens if userspace is 32bit, and kernel space is 64bit, when the 
> elements of the structure changes size doe to conversion?
> Eg:
> struct x {
>    int a;
>    long int b;
>    int c;
> }
> 
> In 32bit userspace, x->a would have offset 0, x->b would have offset 4 
> and x->c would have offset 8. But in 64bit kernel space, the long in 
> would be 64 bit, and so the offset changes: offset x->a = 0, offset x->b 
>   = 4, offset x->c = 12. The structure would then need a special 
> conversion from 32 bit userspace to 64 bit kernel space in order for 
> values in the struct to be accessed correctly. If this is true, then we 

Yes, that structure needs a special conversion for 32/64 platforms.
That's the reason netfilter from plain 2.4.20 kernel does not work
correctly on sparc64 (with 32-bit userspace). Fortunately, there are
not too many such misdesigns in there :)

Even a structure like that is not better:
struct {
    long c;
};
Even if you IPT_ALIGN the whole thing, and memset with zeros, on bigendian
machines "c" (as seen from kernelside) will have its MSB 32-bit filled with
"c" from the userspace. That's the current situation with ipt_MARK for example.

> must only use type with welldifined sizes, that is sizes that does not 
> changes from userspace to kernel space.
> 
> Please correct me if I'm wrong.
> 
> Regards
> Anders Fugmann

You are right. There's only one question left: what and how to change to
a) make everything work on all platforms,
b) introduce as little incompatibilities as possible,
c) avoid kernel code duplication just to maintain backward compatibility,
d) avoid doing #if defined(__sparcv9__) || defined(__hppa64__) (or whatever
   it's called) in kernel headers (I guess it would be difficult to get that
   into mainline as far as I know DaveM, and not without grounds),
e) avoid defining local copies of hack kernel headers and doing something like
   #if sizeof(unsigned long) == 4 && defined (KERNEL_LOOKS_LIKE_SPARC64)
   in userspace (a maintenance nightmare to have several copies of the
   same structure)
all at the same time.

Currently, I see two ways:
1) make a translation function for all currently existing netfilter structures
   that use longs or pointers (difficult, as modules can be added independently),
   like those in arch/sparc64/sys_sparc32.c, and its friends,
2) introduce a new way of passing structures, with new structures, probably
   with new setsockopt/getsockopt numbers, essentially creating an API
   incompatible with the existing one (there are a few other bleeding wounds
   waiting to be solved in the existing interface as I saw).

Maybe combining those two to provide a compatibility layer with 1) and
introduce a new layer with 2). And making the old interface a config
option (CONFIG_NETFILTER_OLD_INTERFACE).

Now I'm interested what other people think about the possibilities...

Regards,
Laszlo
