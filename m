From: Brad Fisher <brad@info-link.net>
Subject: Re: Suggestion for RETURN target
Date: Wed, 03 Dec 2003 11:26:37 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FCE1CCD.C7D69EF9@info-link.net>
References: <Pine.LNX.4.44.0312030908390.5506-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I'm not sure that would do exactly what I require.  If I understand you
correctly, when you fall off the end of a chain called with a "goto"
operation, it would return back 2 chains (or execute the default policy on a
built-in?).  This is different than my suggestion, since as I envision it,
the only time you would go back more than one chain would be if a rule
specifically requested it.  For example,

  iptables -N chain4
  iptables -A chain4 -s 192.168.0.1 -j RETURN --return-to 3

  iptables -N chain3
  iptables -A chain3 -j chain4
  iptables -A chain3 -s 192.168.0.2 -j RETURN --return-to 2
  .. other rules for chain3 here ...

  iptables -N chain2
  iptables -A chain2 -j chain3
  ... other rules for chain2 here ...

  iptables -N chain1
  iptables -A chain1 -j chain2
  ... other rules for chain1 here ...

  iptables -A INPUT -j chain1

In this example, the source ip 192.168.0.1 will cause chain4 to return to
chain1 (the third chain in the call stack), but any other IP will cause it to
fall off the end and return to chain3 (the caller).  After returning to
chain3, an ip of 192.168.0.2 will cause a return to chain1 (the second chain
in the call stack), and any other ip will return to chain2 (the caller).
Well, this assumes any other rules in the respective chains don't chainge
that behavior...

Anyway, this is a contrived example, but hopefully illustrates the idea
better?

Does anyone have any ideas on whether this would be possible to do and if so
would they have any pointers on where I should start looking?  I don't mind
writing the code myself...

-Brad

Henrik Nordstrom wrote:

> On Tue, 2 Dec 2003, Brad Fisher wrote:
>
> > Would it be possible to modify the RETURN target in such a way that it
> > could return to an arbitrary chain in the call stack instead of only to
> > the previous chain?
>
> >From your description it more looks like you need a true jump/goto
> operation, not a "call" operation.. this would be like the current jump
> operation except that the current chain is not saved on the call stack.
>
> Regards
> Henrik
