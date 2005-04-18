From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH] goto port to ipv6
Date: Mon, 18 Apr 2005 09:27:16 +0200
Message-ID: <20050418072715.GE10801@oknodo.bof.de>
References: <425CD235.7060909@outerspace.dyndns.org>
	<4262E109.2010804@trash.net>
	<Pine.LNX.4.61.0504180304580.4321@filer.marasystems.com>
	<426310E5.2030207@trash.net>
	<42635378.6050002@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
Content-Disposition: inline
In-Reply-To: <42635378.6050002@outerspace.dyndns.org>
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

> What's your opinion of my fix included in this IPv6 port (which I fixed
> for IPv4 separately and Harald accepted last friday) to indicate "goto"
> targets in iptables -L listings with a [goto] in the match extension part?
> 
> One alternative could be adding some special character(s) around the
> jump target itself, like *SUBCHAIN or SUBCHAIN* or ->SUBCHAIN or
> something.. Also I have no idea whether one should consider the output
> possibly being used by scripts etc, so I'd appreciate if people could
> give their opinion on this (before it goes upstream :) ...

Hmm. Isn't iptables-save considered the parse-this-in-scripts format?
Such code will have to learn about '-g', right? I have no idea how
many scripts or GUI visualizers would break. :)

Regarding the first column of -L output, from your list I would
choose SUBCHAIN*. I sometimes 'iptables -L | grep ^thischain',
and with a magic character suffix, this reflex will continue
to work.

Now, what magic character to use...

imap_in*    tcp  --  anywhere             anywhere            tcp dpt:imap
ssh_in)    tcp  --  anywhere             anywhere            tcp dpt:ssh
smtp_in.   tcp  --  anywhere             anywhere            tcp dpt:smtp
pop3_in!   tcp  --  anywhere             anywhere            tcp dpt:pop3

Hmm...

best regards
  Patrick
