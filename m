From: Scott MacKay <scottmackay@yahoo.com>
Subject: Re: Adding packet metadata
Date: Wed, 24 Mar 2004 03:52:08 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040324115208.44424.qmail@web13901.mail.yahoo.com>
References: <Pine.LNX.4.44.0403240105250.15222-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0403240105250.15222-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--- Henrik Nordstrom <hno@marasystems.com> wrote:
> On Tue, 23 Mar 2004, Scott MacKay wrote:
> 
> > I wanted to mark up packets with information as
> they pass thru the
> > system. Basically, I want to associate some data
> with a packet during
> > PREROUTING/raw (to read info prior to conntrack)
> and then get that
> > information back during PREROUTING/mangle.  Is
> there a module already
> > written which could perform this?
> 
> MARK should be able to do this.
I actually was thinking of using the MARK for a
different purpose unfortunantly.  Since it is a nice
32bit word, I was thinking of even using only part of
it, but I need it for setting up some match settings
for actual rules.

> > It is not something I would need to have
> accessible to the iptables
> > program, though I will probably need to adjust
> some code to make it
> > accessible to my ip_queue userspace application...
> 
> The MARK value is available (read-only) via
> ip_queue.
That would be my general problem.  The only bit that
seems transmitted back is the payload for evaluation
and update.  Even if I wanted to use MARK, it would
not allow me to alter the value.


__________________________________
Do you Yahoo!?
Yahoo! Finance Tax Center - File online. File on time.
http://taxes.yahoo.com/filing.html
