From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] sparc64 compatibility netfilter patches
Date: Tue, 07 Jan 2003 00:47:56 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030107.004756.67441154.davem@redhat.com>
References: <20030101171654.B25870@linux.karinthy.hu>
	<20030101213205.A27131@linux.karinthy.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: valko@linux.karinthy.hu
In-Reply-To: <20030101213205.A27131@linux.karinthy.hu>
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
   Date: Wed, 1 Jan 2003 21:32:05 +0100

   Improved version follows.
   Both patches had something to improve.

As mentionted, the first patch is OK and I have applied it to
my tree.

You will need to translate the ipt_rateinfo structure somehow as
it is passed in/out of the kernel, not by putting strange (and
decidedly buggy) hacks into the netfilter tools (consider compiling
with a true 64-bit userland on sparc64, your changes break that).
