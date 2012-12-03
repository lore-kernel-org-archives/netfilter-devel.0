From: Behan Webster <behanw-k/hB3zQhLwledRVtV/plodBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH V2 2/3] Remove VLAIS usage from gadget code
Date: Mon, 03 Dec 2012 19:57:33 +0100
Message-ID: <50BCF61D.5000707@converseincode.com>
References: <1351631937-21455-1-git-send-email-behanw@converseincode.com> <1351631937-21455-3-git-send-email-behanw@converseincode.com> <20121031132838.GQ10998@arwen.pp.htv.fi> <509144C0.8000601@converseincode.com> <20121101072116.GA32013@arwen.pp.htv.fi> <20121203115706.GA4760@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Felipe Balbi <balbi-l0cyMroinI0@public.gmane.org>, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Compiling the Linux Kernel with Clang/LLVM
	<llvmlinux-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org>
To: Sebastian Andrzej Siewior <sebastian-E0PNVn5OA6ohrxcnuTQ+TQ@public.gmane.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121203115706.GA4760-E0PNVn5OA6ohrxcnuTQ+TQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

On 12-12-03 12:57 PM, Sebastian Andrzej Siewior wrote:
> On Thu, Nov 01, 2012 at 09:21:16AM +0200, Felipe Balbi wrote:
>> then we can merge to net tree and handle the conflicts when merging to
>> Linus, that'd be fine by me as long as people know how to solve the
>> conflict properly ;-)
> Felipe please drop this patch. I don't like this VLAIS patch and its
> macro magic. I support the goal of compiling the kernel with clang but I
> don't think that this is appropriate. Davem has also his problems with
> the netfilter part so I am no the only one.
You are definitely not the only one. :)

But that's okay. The idea is to find an alternative that works for 
everyone. It was the first attempt, which didn't work out. <shrug>

> *I* think the gadget part of the kernel is something most people won't
> use so it won't show up.
> Anyway, please drop this completely I try to think of something sane.
He actually didn't take the patch. He was asking the netfilter team to 
take it, and they didn't want to. Fair enough.

However, in order to approximate what gcc is doing in code, obviously 
some math is required. The thought was that macros would hide the worst 
of it, trying not to obfuscate what was actually being done.

One of the project members came up with this alternative. How about 
something like this? Less math, though more string pasting. When 
compiled, the unused variables get optimized away. Otherwise the memory 
packing is identical to using VLAIS in gcc.

#define vla_struct(structname) size_t structname##__##next = 0
#define vla_struct_size(structname) structname##__##next

#define vla_item(structname, type, name, n) \
         type * structname##_##name; \
         size_t structname##_##name##__##pad = \
                 (structname##__##next & (__alignof__(type)-1)); \
         size_t structname##_##name##__##offset = \
                 structname##__##next + structname##_##name##__##pad; \
         size_t structname##_##name##__##sz = n * sizeof(type); \
         structname##__##next = structname##__##next + \
                 structname##_##name##__##pad + 
structname##_##name##__##sz;

#define vla_ptr(ptr,structname,name) structname##_##name = \
(typeof(structname##_##name))&ptr[structname##_##name##__##offset]


Then you can do something like this that looks vaguely struct-like:

         vla_struct(foo);
                 vla_item(foo, char,  vara, 1);
                 vla_item(foo, short, varb, 10);
                 vla_item(foo, int,   varc, 5);
                 vla_item(foo, long,  vard, 3);
         size_t total = vla_struct_size(foo);
         char buffer[total];

         vla_ptr(buffer, foo, varc);
         foo_varc = 1;

I've been profiling some sample code around this implementation 
comparing it between compilers, and it approximates the code size and 
speed of using VLAIS in gcc (especially with -O2). It actually performs 
better than the previously proposed macros.

But certainly if anyone has a solution which works for everyone, then 
I'm more than happy to adopt it. The LLVM community has made quite a few 
changes in order to help get Linux working with clang. However, VLAIS is 
not something they are willing to accept (for various reasons). There 
are other patches to LLVM that are still working their way upstream that 
are required to be able to compile Linux as well.

As far as I've been told (though I have been unable to verify), Variable 
Length Arrays In Structs (VLAIS) is a feature which made it into gcc 
along with nested functions by the work on the Ada frontend. By 
contrast, the C99 standard specifies Variable Length Arrays (outside of 
structs) and Flexible Array Members (essentially zero-length arrays at 
the end of a struct), and as such both are supported by gcc and clang.

The LLVMLinux project is a meta-project between the LLVM and Linux 
communities trying to get the toolchain from one working with the code 
from the other.  The LLVMLinux project isn't trying to replace, nor 
break gcc (in fact all the project's kernel patches are tested with gcc 
as well). The idea is to bring another toolchain and set of tools to the 
table and the kernel community.

Behan

-- 
Behan Webster
behanw-k/hB3zQhLwledRVtV/plodBPR1lH4CV8@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
