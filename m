From: Scott MacKay <scottmackay@yahoo.com>
Subject: Re: Packet Fragementation
Date: Wed, 31 Mar 2004 04:34:39 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040331123439.14349.qmail@web13909.mail.yahoo.com>
References: <Pine.LNX.4.44.0403311411260.21126-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0403311411260.21126-100000@filer.marasystems.com>
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
> On Wed, 31 Mar 2004, Scott MacKay wrote:

> > Then, as an option, is there any way to make a
> packet
> > re-enter the conntrack after mangle in PREROUTING?
> 
> 
> What you mean?
Basically, incoming packets will be in a mangled
state, so conntrack likely will not make any useful
associations (data-aware type associations), though it
can provide the service of tying back together
fragments.  I need to de-mangle, but am limited to
mangle/PREROUTING (to get the de-fragmented data, the
same data I would be mangling in the sender's
mangle/POSTROUTING).  After I de-mangle the data, I
would like to generate proper conn track information. 
Basically, I was wondering if I could in any way make
it run the de-mangled packet back thru the conntrack
so it could establish it's data-aware conn tack
information.  If there is code I can add to ip_queue.c
to re-invoke the calls the system makes to hook in
conn track that would be good.  
For what I am doing, I am guessing it would be cleaner
to look at making a kernel level hook, but I am not as
well versed with that style of programming.



__________________________________
Do you Yahoo!?
Yahoo! Finance Tax Center - File online. File on time.
http://taxes.yahoo.com/filing.html
