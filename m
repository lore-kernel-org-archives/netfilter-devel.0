From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: ipt_string / 2.6.x (smp_num_cpus)
Date: Sun, 15 Feb 2004 13:56:46 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040215070352.3019D2C3A4@lists.samba.org>
References: <20040214213849.GD7756@sunbeam.de.gnumonks.org>
Cc: William Stearns <wstearns@pobox.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Cc: Gianni Tedesco <gianni@ecsc.co.uk>,
	ML-netfilter-devel <netfilter-devel@lists.netfilter.org>
In-reply-to: Your message of "Sat, 14 Feb 2004 22:38:49 BST."
             <20040214213849.GD7756@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <20040214213849.GD7756@sunbeam.de.gnumonks.org> you write:
> > int smp_num_cpus =3D 1;
> 
> NR_CPUS is set to the maximum number of cpu's that particular kernel
> image can support.  on x86, that's usually 32.

num_possible_cpus() (which I have a patch for; great minds think
alike) isn't needed here.

In practice, all this allocation and freeing looks bogus anyway: it's
only done at init and cleanup.

How about changing:

	struct string_per_cpu {
		int *skip;
		int *shift;
		int *len;
	};
	
	struct string_per_cpu *bm_string_data=NULL;

to:
	#include <linux/percpu.h>

	struct string_per_cpu {
		int skip[BM_MAX_HLEN];
		int shift[BM_MAX_HLEN];
		int len[BM_MAX_HLEN];
	};

	static DEFINE_PER_CPU(struct string_per_cpu, bm_string_data);

Then you have to use __get_cpu_var(bm_string_data) to access it, but
all the allocation and freeing code vanishes, *AND* each per-cpu
variable is now nicely aligned to cachelines.  The only downside is
that this structure is BIG: it could be halved using "short" instead
of "int", but even so it's 2 * 1024 * 3 == 6k.

Cheers,
Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
