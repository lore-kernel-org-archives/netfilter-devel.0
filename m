From: Imre Gergely <gimre@nextra.ro>
Subject: last rule/default policy
Date: Thu, 11 Sep 2003 14:01:40 +0300 (EEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0309111356430.21741-100000@mx.nextra.ro>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


i'm using the following code to get the last rule of a user defined chain:

for(rule=iptc_first_rule(chain,&h);rule!=NULL;rule=iptc_next_rule(rule,&h)) 
{
  last_rule = rule;
}

if i define 6 rules for example in a user chain, the last should be the 
default RETURN policy rule, is that correct? but there is no default rule. 
how can i retrieve the default policy rule for the chains (not just the 
for the user defined ones)? i need expecially the counters for the chain.

-- 
Gergely Imre                       email: gimre@nextra.ro
sysadmin   mobile: +40-745-105592, office: +40-266-317500
Nextra Tele Com SRL   str. Florilor 28/1, 4100 M-Ciuc, RO
http://www.nextra.ro/gimre                 ICQ# 101510959
