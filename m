From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Packet Fragementation
Date: Wed, 31 Mar 2004 14:12:51 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403311411260.21126-100000@filer.marasystems.com>
References: <20040331113139.87059.qmail@web13910.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott MacKay <scottmackay@yahoo.com>
In-Reply-To: <20040331113139.87059.qmail@web13910.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 31 Mar 2004, Scott MacKay wrote:

> > Just before it is sent out on the wire. Done by a
> > conntrack hook running
> > very last at NF_IP_POST_ROUTING (search for
> > ip_refrag).
>
> Hm, I would guess it is after the mangle table
> processing but will check.

It is the very last thing in the netfilter hooks, well after mangle.

> > Not yet. In the way things are designed the original fragments is
> > completely lost. This is considered a design bug in how conntrack
> > deals with fragmented packets bug unfortunately is how things work.
>
> Then, as an option, is there any way to make a packet
> re-enter the conntrack after mangle in PREROUTING? 

What you mean?

> The problem I will be seeing is that I do some packet
> mangling in mangle/POSTROUTING that I want to un-do
> before the conntrack/PREROUTING get it.

Eh? You can not go back in time..

Regards
Henrik
