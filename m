From: Patrick Schaaf <bof@bof.de>
Subject: Re: netfilter observation
Date: Fri, 27 Jan 2006 07:14:33 +0100
Message-ID: <20060127061433.GA31447@oknodo.bof.de>
References: <20060126171057.7fb9632d.ethy.brito@inexo.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Ethy H. Brito" <ethy.brito@inexo.com.br>
Content-Disposition: inline
In-Reply-To: <20060126171057.7fb9632d.ethy.brito@inexo.com.br>
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

Hello Ethy,

to make a short answer to a long (and well-formulated) question:

> Is this the expect behavior?

Yes. Not only expected, but desired, and relied upon in many many
real world setups. conntracking/NAT and table processing are as
independant as can be. conntracking establishes the concept of
a L4 connection, NAT manipulates its addresses, and table processing
(filter table) is the point where you permit or deny things.

In the filter table, matches like '-m conntrack' can be used to
refer to the NAT state of the packet under inspection.

It's up to you to use this system to implement your policies.

> How to "kill" the old data flow?

per-flow: simulate a suitable TCP RST, or use one of the new style
userlevel conntrack manipulation tools (work in progress, as far
as I know)

per policy and separate implementation: if you have clients changing
IP addresses, implement a system (yourself) which learns when that
happens, and changes rules - independant of conntrack, in the
filter table - which do the right thing for what you want.
To help with such things, is why I invented the ippool match,
which became ipset, which you can find in patch-o-matic. This
is only one example helper. There are lots of other ways.
And the problem for you: how to get at the IP assignment
change "messages", near real time.

best regards
  Patrick
