From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [NF-HIPAC] Performance test results available
Date: Tue, 01 Oct 2002 11:08:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3D996608.5060902@tac.ch>
References: <200209260003.10724.nf@hipac.org> <3D92BBBD.1050609@cs.auc.dk> <200209262117.20361.mbellion@hipac.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Emmanuel Fleury <fleury@cs.auc.dk>,
   Netfilter-devel
 <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: mbellion@hipac.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

>>1) How does behave the CPU load during your test ?
>>As you are using very powerful machines (which is not often the case in
>>reality for firewalls and router), I was really wandering how the CPU
>>power can affect your method.

It is certainly often the case in daily business. But concerning CPU load I did 
some testing this weekend and I will continue testing. Results are phantastic so 
far. Almost no performance issues.

> Sorry, we don't have information about that available. We will have to do 
> additional tests with less powerfull machines to examine that.

Yes, do that.

>>2) How much space was used to store each of the rulessets ?

cat /proc/slabinfo

It's 64 bytes per rule, plus an additional 64 when inserting the first ~1000 
slab objects, depending on the tree balance.

>>Your representation seems to be compact, but I was wandering how ?
>>Maybe a comparison with the size of the iptables rulessets could
>>be relevant.

I've done it and it is amazing. A short overview gave me following rough outline 
with a PIII 500MHz 512KB L2, kernel 2.4.20pre8:

raw TCP (MTU sized packets) throughput                     : 88.5 Mbit/s
10000 non-matching rules before the matching one (iptables):  3.4 Mbit/s
10000 non-matching rules before the matching one (nf-hipac): 85.2 Mbit/s

> The memory usage of our algorithm isn't that much dependent on the number of 
> rules. It's much more dependent on the structure of the ruleset and the type 
> of the used rules. It is e.g. possible that a ruleset with 100 rules uses 
> more memory than a ruleset with 10.000 rules. There are case where nf-hipac 
> uses less memory than iptables and there are case where nf-hipac consumes 
> really a huge amount of memory.

Memory is not an issue nowadays :)

And you can always check /proc/net/nf-hipac

> It's not possible to easily describe the memory usage of nf-hipac. It depends 
> on a lot of factors and interactions of different rule types.
> Our algorithm is designed to have an acceptable memory usage for realistic 
> rulesets. In the tests we made we didn't use realistic rulesets, but 
> completely synthetic ones in order to simultate theoretical worst case 
> performance of the algorithm.

For some people 300 rules are realistic, for our company 3000+ rules are realistic.

> We haven't wrote down memory usage during the tests, so we don't have the 
> numbers available. But as already said, the rulesets were completely 
> syntetic, so the numbers probably don't say much about the algorithm anyway.
> I only remember that memory usage was pretty huge with that synthetic 
> rulesets.

I will conduct further test this coming weekend. An thursday I will present some 
result at the linuxday.lu expo in Luxembourg.

Best regards,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
