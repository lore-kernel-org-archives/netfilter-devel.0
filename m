From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [Debian Bug#218837] limit match not working on sparc64
Date: Fri, 7 Nov 2003 11:43:56 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311071126060.10460-100000@filer.marasystems.com>
References: <20031107014425.GB10258@home.tig-grr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tom Marshall <tommy@home.tig-grr.com>
In-Reply-To: <20031107014425.GB10258@home.tig-grr.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 6 Nov 2003, Tom Marshall wrote:

> Just a random thought -- is an intptr_t the same between kernel and userland
> on all architectures?

No, and may even differ between userland and userlan on the same
architecture if the architecture supports split personality (supporting
both 32 and 64 bit applications)

Any data structures exchanged between userspace and kernel must be using 
fixed with data types only, or else there will be problems like this as 
long as there is split personality architectures.

Pointers is troublesome, and unless the kernel headers exports a pointer
type which is always reflecting the kernel-space pointer size this will be
hard to deal with. But as pointers are different between userspace and 
kernelland there normally should not be any such needs.. iptables is an 
expection as it is userspace who allocates the size of the kernelspace 
structures, with pointers and all.

Now, this kind of thing should not be too hard to solve actually. What is
required is that the header can determine that the pointer representation
differs between user and kernelland, and then adjust the structure
accordingly. The userspace part of the limit match does not use the
pointer so it just needs to be made sure that the structure field of of
the exact same size and alignment as a pointer in the kernel space,
ensuring that the size and layout of the structure is identical in the two
worlds.

Regards
Henrik
