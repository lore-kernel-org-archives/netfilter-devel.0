From: Thomas Heinz <creatix@hipac.org>
Subject: Re: Comments about IPT_ALIGN
Date: Sun, 26 Jan 2003 20:48:53 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E343BA5.5030006@hipac.org>
References: <3E335CB1.9070101@hipac.org> <20030126120159.A3045@linux.karinthy.hu> <3E33C665.9080106@fugmann.dhs.org> <20030126152227.A6811@linux.karinthy.hu> <3E342355.1030707@hipac.org>
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

I wrote:
>        - the end of the struct must be marked by:
>              struct ipt_entry next[0];
>          or
>              long next[0];   // I'm not sure about this!

Well, this is plain nonsense (I don't know why I wrote that).
But here is another idea that does not need #ifdefs:

            struct info
            {
                [...]
            } __attribute__((aligned(__alignof__(u_int64_t))));

This hopefully does the trick.

>        - pointers or arrays of pointers should be avoided but if they're
>          really needed (as in limit) a special pointer type should be
>          used: 32 bit arch: union nf_ptr_t {void *p;
>                                             u_int32_t padd;};
>                64 bit arch: union nf_ptr_t {void *p;
>                                             u_int64_t padd;};
>          Maybe there are better ways to achieve the same
>          (__attribute__ ((aligned (__alignof__(long)))) might work).
                                                           ^^^^^^^^^^
                                             Of course it does _not_ :-)

            I don't think there is a way to avoid the union which
            leads to an #ifdef if we don't restrict ourselves to at most
            one pointer at the end.
            The reason for that is that it does not suffice to require
            a certain alignment for void * but it also must have the
            expected size. Otherwise members that come after pointer
            members might have a different offset (just the same
            argument as for long).
