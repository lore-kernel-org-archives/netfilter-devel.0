From: Laszlo Valko <valko@linux.karinthy.hu>
Subject: Re: Comments about IPT_ALIGN
Date: Sun, 26 Jan 2003 20:43:58 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030126204358.B9418@linux.karinthy.hu>
References: <3E335CB1.9070101@hipac.org> <20030126120159.A3045@linux.karinthy.hu> <3E33C665.9080106@fugmann.dhs.org> <20030126152227.A6811@linux.karinthy.hu> <3E342355.1030707@hipac.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Anders Fugmann <afu@fugmann.dhs.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Heinz <creatix@hipac.org>
Content-Disposition: inline
In-Reply-To: <3E342355.1030707@hipac.org>; from creatix@hipac.org on Sun, Jan 26, 2003 at 07:05:09PM +0100
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

On Sun, Jan 26, 2003 at 07:05:09PM +0100, Thomas Heinz wrote:
> Apart from breaking some existing targets and matches what about the
> following requirements for match/target info structs:
>         - the struct properties stated in my first posting must hold
>           (of course unions can also be used :)
>         - the end of the struct must be marked by:
>               struct ipt_entry next[0];
>           or
>               long next[0];   // I'm not sure about this!
>           or
>               padd_t next[0]; // typedef __u32/__u64 padd_t dep. on arch

I don't have anything con/pro either of these, but I think for
an entry structure (which is followed by other entry structures) it
is wise to use struct ipt_entry next[0].

I'll check if there's already a generic "strictest alignment on this platform"
define in some Linux arch header.

>         - pointers or arrays of pointers should be avoided but if they're
>           really needed (as in limit) a special pointer type should be
>           used: 32 bit arch: union nf_ptr_t {void *p;
>                                              u_int32_t padd;};
>                 64 bit arch: union nf_ptr_t {void *p;
>                                              u_int64_t padd;};

Pointers to be passed between kernel/user space will not work easily
anyway, so this can only be used for kernel private pointers.
For that purpose, this is OK until the netfilter framework provides
facilities to eliminate pointers from kernel-user interface structures.

>           Maybe there are better ways to achieve the same
>           (__attribute__ ((aligned (__alignof__(long)))) might work).

The problem is that you _cannot_ determine from an x-bit userspace compiler
what alignment restrictions do exist on a y-bit kernelspace compiler. Since
they are two distinct compilers.
That's the fundamental flaw in __alignof__/IPT_ALIGN-type "hacking".

>           Btw if only one pointer is needed it could be put at the end
>           before the next member and it should work fine.

As long as the sizeof() structure does not change... Otherwise you'll
get EINVAL from check_entry.

> Of course this would break some matches/targets but apart from that fact
> it should be ok, isn't it? I mean with this solution IPT_ALIGN is no

Otherwise it's ok...

But please realize that struct ipt_entry next[0] at the end effectively
substitutes the missing IPT_ALIGN from the entry, maybe a more correct way.

> longer necessary and no #ifdefs need to be used except for padd_t (which
> is just an option as there is at least one other way to make it work)
> and maybe for nf_ptr_t.

> > 2) introduce a new way of passing structures, with new structures, probably
> >    with new setsockopt/getsockopt numbers, essentially creating an API
> >    incompatible with the existing one (there are a few other bleeding wounds
> >    waiting to be solved in the existing interface as I saw).
> 
> What do you mean by "other bleeding wounds"? Could you explain a bit
> further?
> 
> 
> Thomas

These are the ones that I see currently (mostly because of relevancy to
wordlength issues):

1) Versioning: we are unable to introduce changes into the interface without
   either breaking existing behaviour, or naming the child (module/socket
   option) differently. And we would need it right now :)

2) Kernel private data: there is currently no way to make a kernel-private
   structure that is not visible in the user-kernel interface (see the pointer
   in ipt_limit). I consider it an ugly hack to make a union to hide/cover
   a kernel-side pointer just because it's part of the interface. It should
   not be there at all.

3) Passing arbirary-sized data: I have seen at least two guys in the last
   month here asking how to do it - putting a pointer into the entry structure
   and having the module do copy_from_User is not the right way to do that.


Regards,
Laszlo
