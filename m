From: Patrick Schaaf <bof@bof.de>
Subject: Re: rfc on new match type
Date: Thu, 8 May 2003 07:45:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030508054551.GA25328@oknodo.bof.de>
References: <3EB988B8.707B6111@info-link.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Brad Fisher <brad@info-link.net>
Content-Disposition: inline
In-Reply-To: <3EB988B8.707B6111@info-link.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Brad & list,

>   iptables -A <chain> -m application --application-id 2000 <other params
> here>
> 
> So the application could determine which rules it added by searching for
> all rules with an "application" match with the id 2000.  On the kernel
> side, the match would not actually do anything, it would just match the
> packet.
> 
> The main purpose of this (at least as i see it) would be to have a way
> to ignore rules not added by your application, so you don't have to
> worry (as much) about messing up what other applications may have set
> up.  Or perhaps the application-id could be a string instead of an
> integer, thus allowing you to mark the rules with the application name
> instead.

With a string instead of an id, this is exactly the 'comment' match
that I proposed before, but with a less general application (pun
intended) in mind.

You can, somewhat, emulate it today, with a pattern like this:

	iptables -A chain -s 0.0.0.0 -m string --string "start APP1"
	iptables -A chain ...
	iptables -A chain ...
	iptables -A chain -s 0.0.0.0 -m string --string "end APP1"

Note: string match with unlikely precondition, should not really
compare strings most of the time; no target means no action on
those lines.

Problem with this approach: you need some user space locking to make
sure no two applications add such "bracketed" rules at the same time.

best regards
  Patrick
