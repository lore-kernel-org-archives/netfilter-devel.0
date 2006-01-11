From: Sven Wandersleb <sven.wandersleb@gmail.com>
Subject: Re: bidirectional ip_conntrack_irc
Date: Wed, 11 Jan 2006 02:07:23 +0100
Message-ID: <4dc54d760601101707k1971896dx600e15af5b209a1e@mail.gmail.com>
References: <4dc54d760512300911o5c386f4n76c07d078d5142f8@mail.gmail.com>
	<43BA675A.70101@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43BA675A.70101@trash.net>
Content-Disposition: inline
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

> > is there any Plans to get ip_conntrack_irc working in both directions?
> > Its sad to have connections called NEW, if in fact they are RELATED.
>
> What do you mean by "both directions"?

ip_conntrack_irc only tracks my DCC connections when i send files to
others on  irc. This is necessary because there needs to be a port on
my NAT forwarded to my computer so that the otherone can connect.

If i receive a file from another user its not necesarry to open any
ports, so this is ignored by ip_conntrack_irc. Yet the connection is
(or imho should be considered) related to the main irc connection.

> - mark master conntrack, related connections will inheirit the mark
> iptables -t mangle -A POSTROUTING -p tcp --dport 6667 -j CONNMARK
> --set-mark 0x1

This marks all my normal irc-traffic, but not my incoming DCC transfers

> - mark related connections registered by the irc helper
> iptables -t mangle -A PREROUTING -m state --state RELATED -m helper
> --helper "irc" -j CONNMARK --set-mark 0x1

This worked well for sending files via DCC, but not for receiving.

Its really hard to catch those DCC connections, as they use random ports.
