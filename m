From: Gervasio Bernal <gervasiobernal@speedy.com.ar>
Subject: New target: can't delete rule
Date: Wed, 07 Sep 2005 18:09:55 +0000
Message-ID: <1126116594.3690.35.camel@Pentium>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi all!!!!

I'm from Argentina and I'm developing a new target for iptables with a
college friend. This new target uses the Linux Cryptographic API.

We are debbuging the new extension and we noticed a rare behavior. 
First we inserted the rule like this:
#iptables -t mangle -A INPUT -s xxx.xxx.xxx.xxx -j NEW --param hello
And we don't have problems. 

The problem appears when we tried to erase the rule:
#iptables -t mangle -D INPUT -s xxx.xxx.xxx.xxx -j NEW --param hello
It says: :-(
iptables: No chain/target/match by that name

But, if we put this:
#iptables -t mangle -D INPUT 1
It erases correctly :-)

Why it works with a method and not with the another one?
It can be because we allocating memory in checkentry function and
freeing it  in destroy function?
How can we correct this rare behavior?

Thanks a lot.

Gervasio Bernal - Mendoza - Argentina
Pedro Deis - Mendoza - Argentina
