From: Pablo Neira <pablo@eurodev.net>
Subject: nf_conntrack thoughts [was Re: [PATCH] Conntrack targets/matches
 work with nfconntrack]
Date: Wed, 06 Apr 2005 20:30:21 +0200
Message-ID: <42542ABD.909@eurodev.net>
References: <424F0DD6.9070002@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <424F0DD6.9070002@eurodev.net>
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

Pablo Neira wrote:
> This patch makes work conntrack related matches and targets with both 
> ip_conntrack and nf_conntrack (ipt_state, ipt_CONNMARK, ipt_connmark, 
> ipt_NOTRACK, ipt_conntrack).

I've been having a look at the NAT code and try to figure out how I 
could make it work for both ip_conntrack and nf_conntrack, I don't see 
any obvious yet, I've re-read some mail threads a couple of times. Then 
I happened to think that the key is trying to unify the layout of 
ip_conntrack and nf_conn.

Just a thought, nf_conntrack is meant to replace ip_conntrack. So once 
nf_conntrack gets stable ip_conntrack will disappear. In theory life in 
couple of nf_conntrack and ip_conntrack should be short, right?

Here comes my proposition, why don't we just maintain a nf_conntrack 
tree (without ip_conntrack) and make work matches/targets and ipv4 NAT 
code with it? We can keep both trees in sync (currently we have to do 
such thing anyway) and release a patch that applies to current kernel 
periodically. So brave users could test it and give us feedback.

Once the -nfconntrack tree gets stable enough, push it forward into 
kernel mainline. That way we can spend our time improving nf_conntrack 
and not trying make both share code. This could speed up things.

I think that [ip|nf]_conntrack is not the same problem than ipv4/ipv6 
copy&paste of code.

BTW, I still like Yasuyuki Kozakai's unification patches, since I feel a 
bit unconfortable with all that renamed stuff :)

--
Pablo
