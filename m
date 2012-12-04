From: Behan Webster <behanw-k/hB3zQhLwledRVtV/plodBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH V2 2/3] Remove VLAIS usage from gadget code
Date: Wed, 05 Dec 2012 00:50:16 +0100
Message-ID: <50BE8C38.80002@converseincode.com>
References: <1351631937-21455-1-git-send-email-behanw@converseincode.com> <1351631937-21455-3-git-send-email-behanw@converseincode.com> <20121031132838.GQ10998@arwen.pp.htv.fi> <509144C0.8000601@converseincode.com> <20121101072116.GA32013@arwen.pp.htv.fi> <20121203115706.GA4760@breakpoint.cc> <50BCF61D.5000707@converseincode.com> <20121204222438.GA7624@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Felipe Balbi <balbi-l0cyMroinI0@public.gmane.org>, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Compiling the Linux Kernel with Clang/LLVM
	<llvmlinux-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org>
To: Sebastian Andrzej Siewior <sebastian-E0PNVn5OA6ohrxcnuTQ+TQ@public.gmane.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121204222438.GA7624-E0PNVn5OA6ohrxcnuTQ+TQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

On 12-12-04 11:24 PM, Sebastian Andrzej Siewior wrote:
> On Mon, Dec 03, 2012 at 07:57:33PM +0100, Behan Webster wrote:
>> However, in order to approximate what gcc is doing in code, obviousl=
y
>> some math is required. The thought was that macros would hide the
>> worst of it, trying not to obfuscate what was actually being done.
> Why hide? The thing that is done here is setting up pointers and keep=
 this
> struct as a container. It is never used again, just freed. Therefore =
I would
> suggest to remove and do something different.
=46air enough. That works too.

>> I've been profiling some sample code around this implementation
>> comparing it between compilers, and it approximates the code size an=
d
>> speed of using VLAIS in gcc (especially with -O2). It actually
>> performs better than the previously proposed macros.
> I'm not concerned about speed here. This is an one time setup.
Which is all good in the case of the gadget code.

However VLAIS is used in other places too where code size and speed are=
=20
very important. The proposal was for something which might be used for=20
more than just the gadget code. VLAIS is used in only a handful of=20
places in the kernel. They just happen to be in important parts of the=20
kernel which was why the approach was to change as little as necessary.

>> But certainly if anyone has a solution which works for everyone, the=
n
>> I'm more than happy to adopt it. The LLVM community has made quite a
>> few changes in order to help get Linux working with clang. However,
> That is nice to hear. Besides gcc there is the icc.
Lots of people have brought up icc. Although in the same breath most=20
also say nobody is using it anymore. However, I have no idea whether=20
that is true. The difference is that clang is widely available in most=20
distros; icc is not.

>> VLAIS is not something they are willing to accept (for various
>> reasons). There are other patches to LLVM that are still working
> Is this not described in C99 6.7.2.1p16?
You're thinking of "Flexible Array Members". Essentially the last=20
element in a structure can be the equivalent of a zero length array;=20
something which both gcc and clang support today.

 From C99 6.7.2.1p16:
> 16 As a special case, the last element of a structure with more than=20
> one named member may
> have an incomplete array type; this is called a =EF=AC=82exible array=
 member.=20
> In most situations,
> the =EF=AC=82exible array member is ignored. In particular, the size =
of the=20
> structure is as if the
> =EF=AC=82exible array member were omitted except that it may have mor=
e=20
> trailing padding than
> the omission would imply. Howev er, when a . (or ->) operator has a=20
> left operand that is
> (a pointer to) a structure with a =EF=AC=82exible array member and th=
e right=20
> operand names that
> member, it behaves as if that member were replaced with the longest=20
> array (with the same
> element type) that would not make the structure larger than the objec=
t=20
> being accessed; the
> offset of the array shall remain that of the =EF=AC=82exible array me=
mber,=20
> even if this would differ
> from that of the replacement array. If this array would have no=20
> elements, it behaves as if
> it had one element but the behavior is unde=EF=AC=81ned if any attemp=
t is made=20
> to access that
> element or to generate a pointer one past it.

However if we're considering the C99 standard, it also explicitly=20
disallows the use of VLAs in structs (VLAIS).

 From C99 6.7.2.1 p2:
> 2 A structure or union shall not contain a member with incomplete or=20
> function type (hence,
> a structure shall not contain an instance of itself, but may contain =
a=20
> pointer to an instance
> of itself), except that the last member of a structure with more than=
=20
> one named member
> may have incomplete array type; such a structure (and any union=20
> containing, possibly
> recursively, a member that is such a structure) shall not be a member=
=20
> of a structure or an
> element of an array.
 From C99 6.7.5.2 p4:
> 4 If the size is not present, the array type is an incomplete type. <=
snip>
Essentially all arrays in a structure must not be variable length excep=
t=20
the last member of the array which can be a zero length array (which ca=
n=20
be used to approximate a VLA at the end). It also says that a struct=20
which uses a flexible array member can't be used inside another struct.

>> their way upstream that are required to be able to compile Linux as
>> well.
> I hope the other are "simple" to get in :)
I hope so too. But like the Linux kernel community, the LLVM community=20
have standards and procedures for getting code accepted which take time=
=2E

Thanks,

Behan

--=20
Behan Webster
behanw-k/hB3zQhLwledRVtV/plodBPR1lH4CV8@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
