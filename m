From: Wang Jian <lark@linux.net.cn>
Subject: Re: About matching (also was: Multiple Targets)
Date: Thu, 14 Apr 2005 17:20:51 +0800
Message-ID: <20050414171531.032E.LARK@linux.net.cn>
References: <7174b1e40504140101b5138e0@mail.gmail.com>
	<425E3032.2060409@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Ben La Monica <ben.lamonica@gmail.com>,
	Patrick Schaaf <bof@bof.de>, Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <425E3032.2060409@outerspace.dyndns.org>
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


On Thu, 14 Apr 2005 08:56:18 +0000, Jonas Berlin <xkr47@outerspace.dyndns.org> wrote:

> 
> Interesting idea.. but I think I would still prefer to just write
> support for multiple targets, e.g.
> 
> iptables ... -j MARK --set-mark 10 -j LOG --log-prefix "foo" -j ACCEPT
> 
> The structures currently hold exactly one target, I think it wouldn't be
> too hard extending that to have multiple targets instead, just like
> there already is support for multiple matches. I think it might even be
> easier to implement this than to make targets work properly from a
> "MULTIPLE" target.. but that's just my guess :)
> 
> Maybe one could use some unused bit in the structures to indicate that
> multiple targets are in use in order to remain binary compatible..
> 

I am for multiple targets support.

--previous is a hack and it is not very easy to implement in a clean way,
because of the semantics.

Multiple targets' semantics is clean. This is the advantage.


-- 
  lark
