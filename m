From: Thomas Heinz <creatix@hipac.org>
Subject: Re: Comments about IPT_ALIGN
Date: Sun, 26 Jan 2003 19:05:09 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E342355.1030707@hipac.org>
References: <3E335CB1.9070101@hipac.org> <20030126120159.A3045@linux.karinthy.hu> <3E33C665.9080106@fugmann.dhs.org> <20030126152227.A6811@linux.karinthy.hu>
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

Laszlo Valko wrote:
> You are right. There's only one question left: what and how to change to
> a) make everything work on all platforms,
> b) introduce as little incompatibilities as possible,
> c) avoid kernel code duplication just to maintain backward compatibility,
> d) avoid doing #if defined(__sparcv9__) || defined(__hppa64__) (or whatever
>    it's called) in kernel headers (I guess it would be difficult to get that
>    into mainline as far as I know DaveM, and not without grounds),
> e) avoid defining local copies of hack kernel headers and doing something like
>    #if sizeof(unsigned long) == 4 && defined (KERNEL_LOOKS_LIKE_SPARC64)
>    in userspace (a maintenance nightmare to have several copies of the
>    same structure)
> all at the same time.

Apart from breaking some existing targets and matches what about the
following requirements for match/target info structs:
        - the struct properties stated in my first posting must hold
          (of course unions can also be used :)
        - the end of the struct must be marked by:
              struct ipt_entry next[0];
          or
              long next[0];   // I'm not sure about this!
          or
              padd_t next[0]; // typedef __u32/__u64 padd_t dep. on arch
        - pointers or arrays of pointers should be avoided but if they're
          really needed (as in limit) a special pointer type should be
          used: 32 bit arch: union nf_ptr_t {void *p;
                                             u_int32_t padd;};
                64 bit arch: union nf_ptr_t {void *p;
                                             u_int64_t padd;};
          Maybe there are better ways to achieve the same
          (__attribute__ ((aligned (__alignof__(long)))) might work).
          Btw if only one pointer is needed it could be put at the end
          before the next member and it should work fine.

Of course this would break some matches/targets but apart from that fact
it should be ok, isn't it? I mean with this solution IPT_ALIGN is no
longer necessary and no #ifdefs need to be used except for padd_t (which
is just an option as there is at least one other way to make it work)
and maybe for nf_ptr_t.

> 2) introduce a new way of passing structures, with new structures, probably
>    with new setsockopt/getsockopt numbers, essentially creating an API
>    incompatible with the existing one (there are a few other bleeding wounds
>    waiting to be solved in the existing interface as I saw).

What do you mean by "other bleeding wounds"? Could you explain a bit
further?


Thomas
