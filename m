From: Valko Laszlo <valko@linux.karinthy.hu>
Subject: sparc64 compatibility
Date: Wed, 11 Dec 2002 13:52:40 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021211135240.A12659@linux.karinthy.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: valko@linux.karinthy.hu
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

I have tried to migrate my firewall from x86 to sparc64. It was a
partial success: there is at least one netfilter module (ipt_limit)
which does not work correctly as it is in 2.4.20.

The basic issue is that the user-space and the kernel-space differ
in word-length. This means that sizeof(unsigned long) is 8 when
compiling the kernel module, and 4 when compiling iptables.

This makes IPT_ALIGN(sizeof(struct ipt_rateinfo)) different
in iptables than in the kernel, which results

iptables: Invalid argument

when trying to use the ipt_limit module in

iptables -A FORWARD -m limit --limit 3/sec -j LOG


The root cause is twofold:
We have a rather ugly structure definition (used BOTH for in-kernel
storage AND user-space - kernel-space communication with setsockopt):

struct ipt_rateinfo {
        u_int32_t avg;    /* Average secs between packets * scale */
        u_int32_t burst;  /* Period multiplier for upper limit. */

        /* Used internally by the kernel */
        unsigned long prev;
        u_int32_t credit;
        u_int32_t credit_cap, cost;

        /* Ugly, ugly fucker. */
        struct ipt_rateinfo *master;
};

AND we use the size of this structure to validate the request from user-space.

>From an architectural point of view, it would be nice to have a structure
used for communication between iptables and the kernel module, which does
not include any "Used internally by the kernel" comments (and variables),
and have a different structure for internal kernel use (maybe this could
include the other).
However, the main problem is that variables in the kernel-only part
are not word-length independent (prev & master) AND ipt_limit_checkentry
uses a check like this:

        if (matchsize != IPT_ALIGN(sizeof(struct ipt_rateinfo)))
                return 0;

This check makes it almost impossible to handle my situation in user-land.
So, my proposal is to change ipt_limit_checkentry. Here comes my dilemma:
how to make it correct for my case without breaking all the existing machines?


I would be interested in making this work (I could do that by myself) but I
also would like to see the result generally useful to be merged into
the mainline code. That's the reason I'm posing my questions.

Also, if someone knows right away that some other code in the netfilter
source was not architected to survive such a platform (different word
sizes between kernel and user-space), or some code does an unaligned
memory access (eg. doing 4-byte memory read with the lowest 2 bits of the
address being non-zero results in a trap on SPARC and Alpha), please, tell
me to make it easier for me to use the code.


Please, give me some ideas how I could help to make the code cleaner.

Thanks in advance,
Laszlo
