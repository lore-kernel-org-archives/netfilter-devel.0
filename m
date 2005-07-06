From: "Vincent" <cs83152@csie.chu.edu.tw>
Subject: Private data structure for each iptables rule using
Date: Wed, 6 Jul 2005 14:13:10 +0800
Message-ID: <005a01c581f1$cbbe1260$aa0ba8c0@l7.com.tw>
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

I am writing a individual netfilter module currently currently. I am
encountering a problem that is how can I keep a private data structure
for each 
iptables rule in each connection.
For example

I have such kind rules in the iptables rule-set

iptables -A FORWARD -m mymodule --seq1 -j DROP
iptables -A FORWARD -m mymodule --seq2 -j DROP
Iptables -A FORWARD -m mymodule --seq3 -j DROP

When packets traverses the first rule, I want to keep some private data
in the connection tracking data structure. 
But I think these private data are possible modified by the later
"mymodule" rules. 
So
1. Can I have a private data structure for each iptables rule using ?
2. Any suggestion to prevent different rule modify the same data
structure of connection tracking? Thanks in advance..

Vincent
