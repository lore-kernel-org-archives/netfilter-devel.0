From: Wang Jian <lark@linux.net.cn>
Subject: Re: About matching (also was: Multiple Targets)
Date: Wed, 13 Apr 2005 09:03:12 +0800
Message-ID: <20050413085911.030C.LARK@linux.net.cn>
References: <20050413084249.0309.LARK@linux.net.cn>
	<425C6D58.3090002@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <425C6D58.3090002@outerspace.dyndns.org>
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

My idea is --previous is pseudo match and will duplicate the previous
match rule and mark itself a dup. When the previous rule is deleted,
this one will de-mark the dup, but the matching rule itself still makes
sense.


On Wed, 13 Apr 2005 00:52:40 +0000, Jonas Berlin <xkr47@outerspace.dyndns.org> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Quoting Wang Jian on 2005-04-13 00:48 UTC:
> > The problem is how to handle rule deletion, for example,
> > 
> >   iptables -A INPUT -p tcp --dport 137 -j LOG --log-prefix windows
> >   iptables --previous -j DROP
> > 
> > When the first rule is deleted, then the second --previous is gone?
> 
> Unfortunately not. It gets combined with the rule before that. Or if
> there was no rule before that, it never matches.
> 
> If the official netfilter guys think that --previous rules should be
> deleted also when parent is gone, I can look at how to implemenent that
> at some point.
> 
> - --
> - - xkr47
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.1 (GNU/Linux)
> 
> iD8DBQFCXG1WxyF48ZTvn+4RArUaAKCZ1fg4r0MUbaPA9xvC1EeTESjiLwCfTYFY
> 6e0f30D6sPZ/tEz8zMUzbo8=
> =fU2n
> -----END PGP SIGNATURE-----



-- 
  lark
