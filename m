From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: prohibiting iptables to insert a rule twice
Date: Thu, 6 May 2004 14:33:48 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405061429200.30809-100000@filer.marasystems.com>
References: <409A2621.1020109@aiqa.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ozgur AKAN <akan@aiqa.com>
In-Reply-To: <409A2621.1020109@aiqa.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 6 May 2004, Ozgur AKAN wrote:

> Then inserting same rule afterwards is not meaningful but inserting same 
> rule in other order my be meaningful!

I agree that same rule immediately afterwards is not meaningful.

but the more advanced functions are used the less possible it is to 
automatically determine from a simple match that two seemingly identical 
rules are duplicates. Here is yet another

iptables -m mark --mark 0x01 -d 10.0.0.1 -j ACCEPT
[number of other rules]
iptables -j MARK --set-mark 0x01
[possibly a number of other rules]
iptables -m mark --mark 0x01 -d 10.0.0.1 -j ACCEPT

Only if the rule is only using simple matches not depending on other
contexts and terminal targets can it be easily determined that two
identical rules are duplicates and the second can not match.

Regards
Henrik
