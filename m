From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] sparc64 compatibility netfilter patches
Date: Thu, 02 Jan 2003 01:41:43 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030102.014143.51282263.davem@redhat.com>
References: <20030102085734.GL9467@sunbeam.de.gnumonks.org>
	<20030102.010953.113716640.davem@redhat.com>
	<20030102103126.A32302@linux.karinthy.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@gnumonks.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: valko@linux.karinthy.hu
In-Reply-To: <20030102103126.A32302@linux.karinthy.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

   From: Laszlo Valko <valko@linux.karinthy.hu>
   Date: Thu, 2 Jan 2003 10:31:26 +0100
   
   We could cosmetically beautify it by moving the
   actual implementation from sys_sparc32.c into some other source file
   (maybe net/ipv4/netfilter/nf_sparc32.c?) and call it from sys_sparc32.c,
   this however provides only a maintenance ease. I see that this is
   an important aspect, too.

It isn't even a sparc specific issue, ppc64 mips64 et al. all have
to have a 32-bit translation layer for systemcalls, ioctls, etc.
They basically just copy the sparc64 code in 2.4.x

In 2.5.x we're trying to move this all over into a set of compat.c
files spread over the tree.
