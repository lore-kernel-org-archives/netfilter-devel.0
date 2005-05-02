From: Patrick Schaaf <bof@bof.de>
Subject: Re: LOG and DROP some specified packets in the same iptables rule
Date: Mon, 2 May 2005 09:11:53 +0200
Message-ID: <20050502071153.GG25226@oknodo.bof.de>
References: <20050502060322.GF25226@oknodo.bof.de>
	<000c01c54ee3$0dfb4180$aa0ba8c0@l7.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, 'Patrick Schaaf' <bof@bof.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Vincent <cs83152@csie.chu.edu.tw>
Content-Disposition: inline
In-Reply-To: <000c01c54ee3$0dfb4180$aa0ba8c0@l7.com.tw>
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

> When I want to log and then drop the specified packets, I can write like
> the following 
> iptables rule to reduce the amounts of rule number for performance
> improvement in the system.
> Do you think so?

If all you want to have is performance optimization in the number
of rules, you can easily use the "traditional" approach of a user
defined LOGDROP chain:

iptables -t mangle -N LOGDROP
iptables -t mangle -A LOGDROP -j LOG --log-prefix "LOGDROP: "
iptables -t mangle -A LOGDROP -j DROP

> iptables -t mangle -A FORWARD -p udp --dport 1024: -j DLOG --log-prefix
> "Drop this packet "

then becomes

iptables -t mangle -A FORWARD -p udp --dport 1024: -j LOGDROP

as often as you need it.

Drawback: now the --log-prefix is the same for all callers of LOGDROP.

I wouldn't go to the effort of locally making a copy of LOG, like the
DLOG you propose. It would make more sense, if people agree that this
is a generally useful approach, to make a (hopefully backwards
compatible) new option to LOG, called --drop.

Of course, the general solution, which has been talked about a lot,
but never really reached the point of being incorporated, is to
be able to have multiple targets in the same rule line.

The last time we had this discussion, was about one or two weeks ago. :)

best regards
  Patrick
