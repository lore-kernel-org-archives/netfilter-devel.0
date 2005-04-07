From: Wang Jian <lark@linux.net.cn>
Subject: Re: About matching
Date: Thu, 07 Apr 2005 16:34:48 +0800
Message-ID: <20050407162331.02C8.LARK@linux.net.cn>
References: <20050407113830.02B0.LARK@linux.net.cn>
	<4254E338.6060007@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <4254E338.6060007@outerspace.dyndns.org>
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

Hi Jonas Berlin,


On Thu, 07 Apr 2005 10:37:28 +0300, Jonas Berlin <xkr47@outerspace.dyndns.org> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Wang Jian wrote:
> 
> | 1. A match is marked as dup when insert into chain if it has the same
> | match rule with previous;
> 
> I completely agree with Patrick Schaaf on the side effects.
> 
> | --previous is an indication that the previous matching is used anyway
> | even if the target action changes the evaluation result. You may use the
> 
> I think this feature is one of the strong points of --previous. You can
> perform multiple actions without the possible side-effects from the
> redundant matching, maybe especially when you do a -j RETURN or -j DROP as
> the second (or even third) action.

Yes. In the discussion with Patrick Schaaf, we all agree on this.

> I understand how the automatic optimization would be convenient in that it
> would work with existing solutions, but currently we can't do that reliably,
> and it would require changes to all matchers & targets for them to report
> whether they have side-effects or not. And even then, the --previous match
> would have to be used to explicitly optimize the cases where the implicit
> optimization is disabled because of the side-effects.

I should make it clear, that the algorithm is not only for automatic
optimization. I suggest it because it is very simple and clean and can
be also used by your --previous match.

Actually, because I take side effects of matches and targets into
account, I am against automatic optimization. One should use -m previous
to explicitly trigger optimization. But that doesn't mean the algorithm
itself is bad. In other mails I have said that using this algorithm, the
insertion and deletion is very simple and clean and fast.

> I don't know if it really is worth making all those changes. The --previous
> already gives the same power (although not automatically), is very well
> defined and the side-effects are obvious. Also, the implicity could be
> emulated in userspace to some degree if one would want to.
> 

Post your code finished or not, and we can discuss it :) I wish we can
find the simpler if not simplest solution to current core.

> //
> 
> In the shell script I use to set up my firewall, I have a helper function
> like this:
> 
> iptv () {
> ~  table="$1" ; shift
> ~  chain="$1" ; shift
> ~  verdict="$1" ; shift
> ~  iptables -t $table -A $chain "$@"
> ~  iptables -t $table -A $chain --previous -j $verdict
> }
> 
> So I can do stuff like
> 
> iptv filter INPUT DROP -m random --average 50 -j LOG
> 
> which gives
> 
> iptables -t filter -A INPUT -m random --average 50 -j LOG
> iptables -t filter -A INPUT --previous -j DROP
> 
> - --
> - - xkr47
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.1 (GNU/Linux)
> 
> iD8DBQFCVOM2xyF48ZTvn+4RAlrRAKDn0GG165JQIwUmDGe4yKk9qVhnjQCgnw/B
> ySA4iwsfG6h8MpidBc+U5MM=
> =Unac
> -----END PGP SIGNATURE-----



-- 
  lark
