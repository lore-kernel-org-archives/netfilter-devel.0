From: Borja Pacheco <bpacheco@acisa.es>
Subject: issue with the quota match
Date: Mon, 28 Mar 2005 19:14:15 +0200
Message-ID: <1112030055.6205.23.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter-Devel <netfilter-devel@lists.netfilter.org>
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

Hi all,

I've tried the quota extension and I have a big question about it,
because the module and the kernel counter doesn't agree with the packets
number that have traversed the interfaces...

Here it's the example I tried:


In a first moment I insert a rule with an initial quota of 1000 bytes...
    0     0 ACCEPT     all  --  *      *       0.0.0.0/0
0.0.0.0/0           quota: 1000 bytes

Next, I generate packets and here it's the amazing result....
    8   448 ACCEPT     all  --  *      *       0.0.0.0/0
0.0.0.0/0           quota: 712 bytes

Theoretically, 1000 assigned bytes minus total traffic generated (448
bytes), must originate the remaining quota the rule has: 552. 
BUT IT SAYS 712 BYTES!!!!!

What's wrong????


Thanks in advance for your clarifications.
Best regards.
