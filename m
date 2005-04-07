From: Wang Jian <lark@linux.net.cn>
Subject: Re: About matching
Date: Thu, 07 Apr 2005 11:54:06 +0800
Message-ID: <20050407113830.02B0.LARK@linux.net.cn>
References: <20050407000158.02AA.LARK@linux.net.cn>
	<42542EBA.9050606@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <42542EBA.9050606@outerspace.dyndns.org>
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

I have an idea before, that looks like the following

1. A match is marked as dup when insert into chain if it has the same
match rule with previous;
2. When a match gets deleted followed by match marked as dup , do
housekeeping to make sure the dup relation is correct;
3. When a match is hit, if non-return, the following match marked as dup
is evaluated immediately as hit.

This can be achieved with a little code. But the problem here is when
used in mangle table, the target action may make the matching rule false.

--previous is an indication that the previous matching is used anyway
even if the target action changes the evaluation result. You may use the
same algorithm above and save a lot trouble :)


On Wed, 06 Apr 2005 21:47:22 +0300, Jonas Berlin <xkr47@outerspace.dyndns.org> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Wang Jian wrote:
> 
> | iptables <match rule 1> -j CONNMARK --set-mark value/mask
> | iptables <match rule 1> -j RETURN
> |
> | How many times the match rule 1 is evaluated when matched? If two, then
> | the second time is waste of CPU cycle.
> 
> It evaluates twice. I have made a "previous" match which I haven't finished
> into a patch yet (some cleanup, documentation and iptables-save & -restore
> support). It lets you do the above like this:
> 
> iptables <match rule 1> -j CONNMARK --set-mark value/mask
> iptables --previous -j RETURN
> 
> | Then think these three
> |
> | iptables <match rule 1> -j CONNMARK --set-mark value/mask
> | iptables <match rule 1> -j CONNMARK --restore --mask mask
> | iptables <match rule 1> -j RETURN
> |
> | Are there any optimization for such case?
> 
> I would guess mask restoring is usually done globally without matching some
> specific criteria.. but nevertheless, the --previous could be used here if
> wanted, it can be used many times in a row.
> 
> I'll try to finish off the patch tomorrow.
> 
> - --
> - - xkr47
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.1 (GNU/Linux)
> 
> iD8DBQFCVC64xyF48ZTvn+4RAi8pAJ4sjXT1KZf5Ora6S0Rr5dCXmcGj9gCgzKQi
> OUx6jdlw3FvPEtVuWgZ2/j8=
> =bp5F
> -----END PGP SIGNATURE-----



-- 
  lark
