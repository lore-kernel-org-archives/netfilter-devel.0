From: Patrick Schaaf <bof@bof.de>
Subject: Re: conntrack and ICMP errors
Date: Thu, 10 Apr 2003 22:08:16 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030410200816.GA18520@oknodo.bof.de>
References: <20030410182056.GA17723@bzorp.balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Balazs Scheidler <bazsi@balabit.hu>
Content-Disposition: inline
In-Reply-To: <20030410182056.GA17723@bzorp.balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Balazs,

I'm skipping your UDP redirect stuff (too much for my brain now), but
one note on the TCP part.

In the situation you allude to at the end of your mail, think about
how the _client_ will react to the ICMP error (which you route through
to it, don't you?) What will the client do? What effect will that have
on the netfilter box? I can tell you: it will sit there and patiently
wait for the other side to come back up, keeping the TCP connection
ESTABLISHED, just like the iptables box. And, better yet: if the
intermittent reason for the "destination unreachable" goes away,
and we find out the server did NOT crash, but its link was flakey,
my ssh connection STILL WORKS THE SECOND I TYPE AGAIN!

Yes, I would call that intentional.

To summarize:

	ICMP messages DO NOT TERMINATE TCP CONNECTIONS.

Please print that out, and eat the printout. You may add salt and pepper.

best regards
  Patrick
