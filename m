From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH 1/2] flow match feedback
Date: Tue, 12 Jul 2005 13:38:31 +0100
Message-ID: <42D3B9C7.1070507@ufomechanic.net>
References: <20050628234912.GB23662@wsc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050628234912.GB23662@wsc.edu>
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

Josh Samuelson wrote:
> Greetings all,
> 
> This patch requires Pablo Neira's conntrack event API patch.  It's been
> many months since I've posted, but I've been tracking the changes that
> have been made and making the necessary revisions to the code.
> Thanks Pablo for the heads-up on my silly misuses of the locks,
> hopefully I've got those cleared up. :)  I also added the ability to
> track new and established flows to the module.  Also I used
> Patrick McHardy's iterative state method of looping over the hashes
> for the proc files.  I figured it was high time to submit it again.
> 
> Quoting the man page for the match:
> 
>   This module allows you to match a packet when the specified number of
>   known protocol connections is exceeded.  The matches can be made
>   against generic IP, ICMP, TCP or UDP flow counters.  This match can be
>   used in all tables but raw.
> 
>   Matches when >= n flows exist
> 
>   --DIR-PROTOCOL[-TYPE] [!] n
>       where DIR is orig or repl for original and reply directions
>       respectively.  PROTOCOL is ip, icmp, tcp or udp.  TYPE is n or
>       e.  TYPE n is for new connections.  TYPE e is for established
>       connections.  Specifying no TYPE results in the comparison being
>       made for all PROTOCOL connections regardless of TYPE.
> 
> The patch should apply to 2.6.12 and iptables v1.3.1.  Though I'll
> be away from my email for the next week, I would appreciate any
> feedback.  Questions?  Comments?  Useful/Not?

iptables -t filter -A INPUT -p tcp --dport 22 -m flow --orig-tcp-n 3 -j DROP

I imagined that the -n in --orig-tcp-n would mean that the rule
condition is only true when being matched against a new connection,
howewever when I created my 3rd connection all packets on all
connections were dropped.

I guess there should be a rule target that drops the connection and
removes the conntrack entry of the new connection as well, DROP seems to
permit creation of the new conntrack, hence the rule continuing to apply.

I can get what I expected doing this:
iptables -t filter -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW
-m flow --orig-tcp-n 3 -j DROP

But I am then not sure what the -n was signifying.

By using the second rule with ctstate, I get 4 entries in
/proc/net/ip_conntrack dport=22 and one of them is stuck on "unreplied",
other new connections do not even enter the conntrack table.

However, I notice that when the conneciton is closed and in TIME_WAIT it
still counts towards the limit.  While there may be no way around this
for UDP where there is no explicit close event, I feel for TCP
connections this new module ought to count the connection as closed
before the conntrack is destroyed, for whatever happens we expect only a
few more packets on the connection and it is a shame to hold up any new
connections because of that. Proper close conntracks are perhaps brief
enough, but only perhaps.

Amin
