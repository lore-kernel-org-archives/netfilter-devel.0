From: Emmanuel Fleury <fleury@cs.auc.dk>
Subject: Re: [NF-HIPAC] Performance test results available
Date: Thu, 26 Sep 2002 09:48:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3D92BBBD.1050609@cs.auc.dk>
References: <200209260003.10724.nf@hipac.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: nf@hipac.org, netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

First, your results are really impressive in comparison to iptables...

I was wandering two things:

1) How does behave the CPU load during your test ?

As you are using very powerful machines (which is not often the case in
reality for firewalls and router), I was really wandering how the CPU
power can affect your method.

2) How much space was used to store each of the rulessets ?

Your representation seems to be compact, but I was wandering how ?
Maybe a comparison with the size of the iptables rulessets could
be relevant.

Regards
-- 
Emmanuel

When all else fails, read the instructions.
   -- Allen's Axiom
