From: Laszlo Valko <valko@linux.karinthy.hu>
Subject: Re: [PATCH] sparc64 compatibility netfilter patches
Date: Thu, 2 Jan 2003 10:20:11 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030102102011.A28219@linux.karinthy.hu>
References: <20030101171654.B25870@linux.karinthy.hu> <20030101213205.A27131@linux.karinthy.hu> <20030101.222223.122334112.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20030101.222223.122334112.davem@redhat.com>; from davem@redhat.com on Wed, Jan 01, 2003 at 10:22:23PM -0800
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jan 01, 2003 at 10:22:23PM -0800, David S. Miller wrote:
> 
> The hack for building the tools is wrong, there are 64-bit
> compilers and userspace available.

I totally agree that this hack is the wrong way to do it.
It will definitely not work with 64-bit userspace.

> The real fix for that (for when your tools are 32-bit) is
> to run "sparc32 /bin/sh" and compile in that environment.

I don't see how that would solve our problem. It will probably
produce working code with 64-bit userspace, but not in the mixed
bit-length case.

Actually, the hack with KERNEL_64_USERSPACE_32 in the tools had
existed before I even looked at the code. It was too tempting to
extend it to my case even tough I know it's not good :)


There are basically two "good" and a "worse" solution:

1) make the kernel interface saner by excluding longs and pointers
   altogether, and cleaning it up by separating "interface" and
   "kernel internal" variables/structures (complicated, introducing
   incompatible API changes),

2) do kernel side 32-64 bit conversions (ugly, big performance
   penalty, looks like a big hack, difficult to maintain),

3) make a similar hack, like there currently is, but with correct
   userspace-kernelspace bit-length checking, and do the magic in
   the tools (even uglier, but no performance penalty and easier to
   maintain).

None of them are simple.

In the long run, I vote for the first one.
If I have a spare week, I might as well try to "sink" into the
netfilter code, and implement something...

> I'll be looking at the kernel side patch next, it should be
> ok.

Thanks.

Laszlo
e-mail: <valko@linux.karinthy.hu>
