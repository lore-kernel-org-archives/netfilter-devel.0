From: Thomas Heinz <creatix@hipac.org>
Subject: Re: Comments about IPT_ALIGN
Date: Mon, 27 Jan 2003 00:09:14 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E346A9A.5020305@hipac.org>
References: <3E335CB1.9070101@hipac.org> <20030126120159.A3045@linux.karinthy.hu> <3E33C665.9080106@fugmann.dhs.org> <20030126152227.A6811@linux.karinthy.hu> <3E342355.1030707@hipac.org> <20030126204358.B9418@linux.karinthy.hu>
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
>>        - pointers or arrays of pointers should be avoided but if they're
>>          really needed (as in limit) a special pointer type should be
>>          used: 32 bit arch: union nf_ptr_t {void *p;
>>                                             u_int32_t padd;};
>>                64 bit arch: union nf_ptr_t {void *p;
>>                                             u_int64_t padd;};
> 
> 
> Pointers to be passed between kernel/user space will not work easily
> anyway, so this can only be used for kernel private pointers.

True.

> For that purpose, this is OK until the netfilter framework provides
> facilities to eliminate pointers from kernel-user interface structures.

Yes, those pointers in the kernel-user interface are a real problem :)

>>          Maybe there are better ways to achieve the same
>>          (__attribute__ ((aligned (__alignof__(long)))) might work).
> 
> 
> The problem is that you _cannot_ determine from an x-bit userspace compiler
> what alignment restrictions do exist on a y-bit kernelspace compiler. Since
> they are two distinct compilers.
> That's the fundamental flaw in __alignof__/IPT_ALIGN-type "hacking".

Hm, but we agree that the alignment of types of fixed width is the
same even if x != y, e.g. __u64 is 8 byte aligned in sparc64 user and
kernel space. The problem of stacking structs with different alignment
requirements next to each other can be solved by aligning the structures
according to what you call "strictest alignment on this platform"
which IMO can be expressed by:
   struct foo {[...]}__attribute__((aligned(__alignof__(u_int64_t))));

Of course the problem of "valid user pointers" (in contrast to kernel
private pointers) remains but as you stated they simply should not be
used as they don't work as expected (at least on some architectures).

Furthermore, as far as I can see, the fact that one cannot use
dynamically sized structs is not caused by kernel-user structures
being too restrictive but by the userspace framework which forces
a target/match to tell its size at compile time.

> But please realize that struct ipt_entry next[0] at the end effectively
> substitutes the missing IPT_ALIGN from the entry, maybe a more correct way.

Yes, it's nothing more after all, but this would be the only problem
if we had no pointers and the members were of known bit width.

> 1) Versioning: we are unable to introduce changes into the interface without
>    either breaking existing behaviour, or naming the child (module/socket
>    option) differently. And we would need it right now :)
> 
> 2) Kernel private data: there is currently no way to make a kernel-private
>    structure that is not visible in the user-kernel interface (see the pointer
>    in ipt_limit). I consider it an ugly hack to make a union to hide/cover
>    a kernel-side pointer just because it's part of the interface. It should
>    not be there at all.
> 
> 3) Passing arbirary-sized data: I have seen at least two guys in the last
>    month here asking how to do it - putting a pointer into the entry structure
>    and having the module do copy_from_User is not the right way to do that.

Full ack.

Thanks for your explanations.


Thomas
