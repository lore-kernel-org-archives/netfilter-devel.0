From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [netfilter-core] asymptotic complexity when creating new chains and rules
Date: Sun, 04 Jan 2004 14:51:28 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040104043038.16CC32C2C1@lists.samba.org>
References: <200401031636.11291.mail@stefan-winter.de>
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stefan Winter <mail@stefan-winter.de>
In-reply-to: Your message of "Sat, 03 Jan 2004 16:36:10 BST."
             <200401031636.11291.mail@stefan-winter.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <200401031636.11291.mail@stefan-winter.de> you write:
> But, if you iterate this process a hundred times (with increasing "N" in the 
> chain name, so that you get 200 chains with 200*62 rules altogether), adding 
> the chains slows down with every new chain (first chain: 20 ms, all chains 
> together 150 SECONDS). This seems to imply that adding a chain (or rule) is 
> of complexity O(n) with n being the number of rules/chains already in the 
> table, where one would expect O(1). Is that right?

Yes.  In particular, the userspace is theoretically O(1), in that if
you read the chains once, kept that copy, and every time updated it
and committed it to the kernel, that would be O(1).  But most uses of
libiptc do "read all rules, insert new one, repeat".  Secondly, the
kernel isn't O(1): it checks for loops, and actually calls all the
rules' matches and targets to check they like where they are.

This is why Harald is working on pkttables, which abandons the whole
"flip the whole table into the kernel approach".

Cheers,
Rusty.
PS.  netfilter-devel is the correct mailing list.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
