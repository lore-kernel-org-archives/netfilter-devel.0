From: Patrick McHardy <kaber@trash.net>
Subject: Re: bidirectional ip_conntrack_irc
Date: Tue, 03 Jan 2006 13:00:26 +0100
Message-ID: <43BA675A.70101@trash.net>
References: <4dc54d760512300911o5c386f4n76c07d078d5142f8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Wandersleb <nibbler@saeuferleber.de>
In-Reply-To: <4dc54d760512300911o5c386f4n76c07d078d5142f8@mail.gmail.com>
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

Sven Wandersleb wrote:
> Hi List,
> 
> is there any Plans to get ip_conntrack_irc working in both directions?
> Its sad to have connections called NEW, if in fact they are RELATED.

What do you mean by "both directions"?

> I need it, as i want to catch DCC downloads to mark/route them to a
> broader link than the default one.

Two possibilities:

- mark master conntrack, related connections will inheirit the mark
iptables -t mangle -A POSTROUTING -p tcp --dport 6667 -j CONNMARK 
--set-mark 0x1

- mark related connections registered by the irc helper
iptables -t mangle -A PREROUTING -m state --state RELATED -m helper 
--helper "irc" -j CONNMARK --set-mark 0x1

In both cases you need to set the packet mark from the connection
mark and use that in your routing rules.
