From: "Vincent" <cs83152@csie.chu.edu.tw>
Subject: Add rule information into ip_conntrack in the match module
Date: Wed, 25 Jan 2006 09:10:25 +0800
Message-ID: <015f01c6214c$27f33840$aa0ba8c0@l7.com.tw>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

Hello folks

I am writing a match module (ex. XYZ match) currently. One of the
important feature is while the specified iptable rule(ex. Rule1)
included XYZ match (-m XYZ) hit the packet.
I hope the match module will "remember" the status and will always hit
the continous packets of the same connection.
Besides, only the match module of original hitting rule(Rule1) can
return true for the packets of the same connection.
Other iptable rule which also have XYZ match can not hit the packets of
the same connection anymore.

One method to solve this problem I have known is we can record the
iptables rule (ex. ipt_entry) information into ip_conntrack data
structure.
And we can use the rule-info of ip_conntrack in the later match function
comparison. But one critical point is that we can not get the ipt_entry 
(or other similar info) in the match function of match module...  :(

So I am thinking whether exist any other method or substitute one to
solve the problem.
Any suggestion or idea is welcome, thanks

Vincent
