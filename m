From: Nuutti Kotivuori <naked@iki.fi>
Subject: Re: [PATCH] Very first try: ipt_connrate patch.
Date: Thu, 19 Feb 2004 21:05:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <87znbe7uve.fsf@iki.fi>
References: <87bro9fiqq.fsf@iki.fi>
	<20040214201444.GS7756@sunbeam.de.gnumonks.org>
	<87ptcfahm4.fsf@iki.fi>
	<20040219182818.GF4797@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040219182818.GF4797@sunbeam.de.gnumonks.org> (Harald Welte's
 message of "Thu, 19 Feb 2004 19:28:18 +0100")
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:
> On Mon, Feb 16, 2004 at 04:22:11AM +0200, Nuutti Kotivuori wrote:
>> This is intentional. 'prev' is used to store a jiffies value, as by
>> the comment - which is an unsigned long on all platforms I
>> believe. 'avgrate' is again something calculated internally in the
>> algorithm, and it should be 32 bits to keep the assumptions I make
>> valid.
>
> the issue is sparc64, which has 32bit userspace and 64bit
> kernelspace.  So libipt_XX.c will be compiled with a 32bit unsigned
> long, and the kernel with a 64bit unsigned long :(

Ah, right! There's a mixup between two things here.

First of all, you are correct, struct ipt_connrate_info is at fault:
,----
| struct ipt_connrate_info
| {
|        /* Per connection transfer rate, in bytes per second. If
|           'from' is smaller or equal to 'to', rate is matched to be
|           inside the inclusive range [from,to], otherwise rate is
|           matched to be outside the inclusive range [to,from]. */
|        unsigned long from, to;
| };
`----

And that was just a mistake from my side - I will change them to be
u_int32_t. The value they compare against is already u_int32_t.

But, the other structure, namely ip_conntrack_rate:
,----
| struct ip_conntrack_rate {
|        /* jiffies of previous received packet */
|        unsigned long prev;
|        /* average rate of tokens per jiffy */
|        u_int32_t avgrate;
| };
`----

This is a part of the ip_conntrack struct. This structure seems to be
inside #ifdef __KERNEL__ to begin with, and there are no need for
userspace software to access it. So I believe it is fine.

But if it would be needed from userspace, what is the correct datatype
that will hold a kernel jiffies value both inside the kernel and in
userspace?

Thanks,
-- Naked
