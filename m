From: Thomas Heinz <creatix@hipac.org>
Subject: Re: Comments about IPT_ALIGN
Date: Sun, 26 Jan 2003 14:58:02 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E33E96A.5080903@hipac.org>
References: <3E335CB1.9070101@hipac.org> <20030126120159.A3045@linux.karinthy.hu> <3E33C665.9080106@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Laszlo Valko <valko@linux.karinthy.hu>,
 netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Anders Fugmann <afu@fugmann.dhs.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Anders

You wrote:
> Does this not pose an interresting problem?
> What happens if userspace is 32bit, and kernel space is 64bit, when the 
> elements of the structure changes size doe to conversion?
> Eg:
> struct x {
>   int a;
>   long int b;
>   int c;
> }
> 
> In 32bit userspace, x->a would have offset 0, x->b would have offset 4 
> and x->c would have offset 8. But in 64bit kernel space, the long in 
> would be 64 bit, and so the offset changes: offset x->a = 0, offset x->b 
>  = 4, offset x->c = 12. 

As member b of struct x must be 8 byte aligned we have
offsetof(struct x, b) = 8 (which implies offsetof(struct x, c) = 16).

In general the alignment requirement for a type is inherited by the
struct members (recursively). Of course there may be architectures
where there are no alignment requirements at all, i.e.
__alignof__(x) == 1.

> The structure would then need a special 
> conversion from 32 bit userspace to 64 bit kernel space in order for 
> values in the struct to be accessed correctly. If this is true, then we 
> must only use type with welldifined sizes, that is sizes that does not 
> changes from userspace to kernel space.

Actually this is not true for some existing targets and matches, e.g.:

     - ULOG: struct ipt_ulog_info {
                     unsigned int nl_group;
                     size_t copy_range;
                     size_t qthreshold;
                     char prefix[ULOG_PREFIX_LEN];
             };
     - MARK: struct ipt_mark_info {
                     unsigned long mark, mask;
                     u_int8_t invert;
             };
     - limit: struct ipt_rateinfo {
                      u_int32_t avg;    /* Average secs between packets 
* scale */
                      u_int32_t burst;  /* Period multiplier for upper 
limit. */
                     /* Used internally by the kernel */
                     unsigned long prev;
                     u_int32_t credit;
                     u_int32_t credit_cap, cost;

                     /* Ugly, ugly fucker. */
                     struct ipt_rateinfo *master;
              };

       The unsigned long prev in the middle does not hurt because it
       is automatically 8 byte aligned by avg and burst. Because
       the pointer (master) is at the end of the struct it does not
       cause any problems except that the whole struct must be
       aligned correctly.

Since I assume that ULOG and MARK work perfectly on sparc64 I must
be missing something that makes the internal memory layout of the
structs (i.e. the member offsets) equal in user and kernel space
(or my assumption is wrong ;-).

It would be kind if someone could fix my brainbug :)

BTW, pointers and arrays of pointers within target or match
structs can be forced to have the 8 byte alignment requirement
(on sparc64 and parisc64) by simply putting them into a
union: union {void *p; __u64 pad;}


Regards,

Thomas
