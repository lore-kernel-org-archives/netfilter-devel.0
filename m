From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: MARK-Operations problems
Date: Thu, 8 Jul 2004 08:57:51 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0407080852320.16639-100000@filer.marasystems.com>
References: <20040708021802.GL6161@samad.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Alexander Samad <alex@samad.com.au>
In-Reply-To: <20040708021802.GL6161@samad.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 8 Jul 2004, Alexander Samad wrote:

> Double checked this and I am pretty sure its pacthed all the right
> modules are there (the ones that are created with the patch), the
> strange bit is even a working command -j MARK --set-mark 0x01 fails with
> the same error, but the unpatched iptables doesn't on the same patches
> kernel

The fact that the unpatched iptables works is a quite clear indication 
that the running kernel is not patched, at least not with the MARK 
operations patch.

When iptables is built it is using the same headers as the kernel. If the 
headers used when building iptables is different from those used when 
building the running kernel then operations on matches/extensions will 
fail with size errors.

Another occation when such errors can happen is in special cases on 64-bit
machines with split personality, with kernel running in 64-bits and
userspace in 32-bits. This is maybe seen on SPARC-64 and Opteron I think,
but is not very likely to be the cause of errors with the MARK operation.


Regards
Henrik
