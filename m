From: don-netf@isis.cs3-inc.com (Don Cohen)
Subject: re: Question: Variable sized matchinfo
Date: Mon, 20 Jan 2003 22:40:43 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <15916.60267.562015.732567@isis.cs3-inc.com>
References: <20030120232634.24011.21218.Mailman@kashyyyk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
In-Reply-To: <20030120232634.24011.21218.Mailman@kashyyyk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

 > I want to write a match where it would be nice to pass a variable sized 
 > matchinfo to kernelspace.
The answer when I asked this question in connection with u32 was no.
In fact,
I asked:
  > Would it work to make that 10 into a module parm (or three) ?
Harald answered:
  unfortunately not.  The size of this structure needs to be known at
  compile time of the kernel and iptables userspace (and they have to be
  the same, obviously).

 > Is this possible ? I want to avoid always using the largest possible 
 > values (2^16 + a few bytes).
 > The data in question is a bpf program compiled with pcap_compile ..
 > This is probably not the most useful match but i think it beats u32 
 > because bpf syntax is already well-known
 > and very pleasant to use.
Thanks for the reference.  I'll read about it.  I assume you mean the
u32 I posted recently.
So far the bpf language doesn't strike me as pleasant to use compared
to the small language I made up for u32, but maybe that's just cause
I'm not used to it.  
I gather 2^16 is the maximum possible size of a bpf program.
How about supplying several different variants of your module,
one that has data size 128 bytes, another with size 1K, another 8K
and finally 64K.
