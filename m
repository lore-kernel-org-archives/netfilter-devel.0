From: Ozgur AKAN <akan@aiqa.com>
Subject: Re: prohibiting iptables to insert a rule twice
Date: Thu, 06 May 2004 14:48:49 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <409A2621.1020109@aiqa.com>
References: <Pine.LNX.4.44.0405061320210.30218-100000@filer.marasystems.com> <409A239B.2040409@aiqa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>,
 "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ozgur AKAN <akan@aiqa.com>
In-Reply-To: <409A239B.2040409@aiqa.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Lets examine this stuation

1 iptables -A INPUT -p tcp -d 10.1.1.2 --dport 80 -j ACCEPT
2 iptables -A INPUT -m fuzzy --lower-limit 100 --upper-limit 1000 -j REJECT
3 iptables -A INPUT -p tcp -d 10.1.1.2 --dport 80 -j ACCEPT

by the example below 3th rule`s byte/packet count  is used to check how 
effective 2nd rule is used!

This is a good example, I hope.

Then inserting same rule afterwards is not meaningful but inserting same 
rule in other order my be meaningful!

-- 
Ozgur Akan
