From: Scott MacKay <scottmackay@yahoo.com>
Subject: Re: Packet Fragementation
Date: Wed, 31 Mar 2004 03:31:39 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040331113139.87059.qmail@web13910.mail.yahoo.com>
References: <Pine.LNX.4.44.0403310138340.11956-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0403310138340.11956-100000@filer.marasystems.com>
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
> On Tue, 30 Mar 2004, Scott MacKay wrote:
> > If so, where in the whole netfilter process is the
> > packet re-fragmented? 
> 
> Just before it is sent out on the wire. Done by a
> conntrack hook running
> very last at NF_IP_POST_ROUTING (search for
> ip_refrag).
Hm, I would guess it is after the mangle table
processing but will check.

> > Is there a way to tell how big an
> > incoming message awaiting delivery via ipq_read()
> is? 
> 
> libipq does not support this, but it should be
> possible to peek the size 
> with a recvfrom using MSG_PEEK | MSG_TRUNC.
TY!  This will help alot.

> > Is there a way to keep conntrack from passing up a
> > de-fragmented packet (so still have conntrack make
> > it's session info, but not pass up defragmented
> data)?
> 
> Not yet. In the way things are designed the original
> fragments is 
> completely lost. This is considered a design bug in
> how conntrack deals 
> with fragmented packets bug unfortunately is how
> things work.
Then, as an option, is there any way to make a packet
re-enter the conntrack after mangle in PREROUTING? 
The problem I will be seeing is that I do some packet
mangling in mangle/POSTROUTING that I want to un-do
before the conntrack/PREROUTING get it.  I hoped to
use  raw/PREROUTING, but if mangle/POSTROUTING
generates a whole packet and raw/PREROUTING sees
fragments, then it just won't work.  If, in
mangle/PREROUTING (namely IP_QUEUE kicked off by
mangle/PREROUTING) I can do my un-mangling and make it
run thru conntrack again as a new packet then
everything is cool.  Thanks in advance!

__________________________________
Do you Yahoo!?
Yahoo! Finance Tax Center - File online. File on time.
http://taxes.yahoo.com/filing.html
