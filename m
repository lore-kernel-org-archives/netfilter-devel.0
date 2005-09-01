From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 0/10] compatibility between {ip,nf}_conntrack
Date: Thu, 01 Sep 2005 18:13:40 +0900 (JST)
Message-ID: <200509010913.j819Dfcl004700@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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


Hi,

I tried to solve compatibility issue, and these patches are my current
solutions. Concepts are:

- inline functions
	Their functions make matches/targets easy to access internal members
	in conntrack like glue functions, and they adds very little costs
	like macros.
- helper/conntrack match
	It's difficult to hide internal members without extra costs or
	complexity in their codes, so these patch just use #ifdef switch.

And I also have a patch for CLUSTERIP, but I'll send it after recent patches
are merged into nf_conntrack tree.

Comments ?

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
