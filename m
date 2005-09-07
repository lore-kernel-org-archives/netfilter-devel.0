From: Pablo Neira <pablo@eurodev.net>
Subject: Re: New target: can't delete rule
Date: Thu, 08 Sep 2005 00:30:38 +0200
Message-ID: <431F6A0E.1090707@eurodev.net>
References: <1126116594.3690.35.camel@Pentium>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gervasio Bernal <gervasiobernal@speedy.com.ar>
In-Reply-To: <1126116594.3690.35.camel@Pentium>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Gervasio Bernal wrote:
> I'm from Argentina and I'm developing a new target for iptables with a
> college friend. This new target uses the Linux Cryptographic API.
> 
> We are debbuging the new extension and we noticed a rare behavior. 
> First we inserted the rule like this:
> #iptables -t mangle -A INPUT -s xxx.xxx.xxx.xxx -j NEW --param hello
> And we don't have problems. 
> 
> The problem appears when we tried to erase the rule:
> #iptables -t mangle -D INPUT -s xxx.xxx.xxx.xxx -j NEW --param hello
> It says: :-(
> iptables: No chain/target/match by that name
> 
> But, if we put this:
> #iptables -t mangle -D INPUT 1
> It erases correctly :-)
> 
> Why it works with a method and not with the another one?
> It can be because we allocating memory in checkentry function and
> freeing it  in destroy function?
> How can we correct this rare behavior?

I bet that you have a pointer in the private info section of the target. 
See that iptables sets that pointer to NULL at rule creation. 
Afterwards, once checkentry() is called, such pointer won't be NULL anymore.

At removal, the rule built by iptables sets that pointer to NULL. Such 
rule will be compared with the ruleset hold in kernel space but no 
matches will be found since the pointers mismatch.

This problem is well known and it's very easy to fix up (look for 
userspacesize and offsetof in iptables/extensions). See ipt_limit, 
ipt_CLUSTERIP...

But it's *even* easier to figure out what's wrong with yout module if 
you post it here, in the mailing list.

--
Pablo
