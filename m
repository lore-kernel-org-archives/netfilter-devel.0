From: James Ralston <qralston+ml.netfilter-devel@andrew.cmu.edu>
Subject: Re: separation of sysctl and tcp-window-tracking patch?
Date: Thu, 12 Dec 2002 03:05:33 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0212120252370.3113-100000@shieldbreaker.l33tskillz.org>
References: <20021101021236.GA16306@pc.ilinx>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20021101021236.GA16306@pc.ilinx>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I was catching up on back netfilter-devel messages and saw this.

I absolutely agree.  I would *really* like to be able to tune various
netfilter-related settings via /proc, regardless of my opinions on the
tcp-window-tracking patch.

(My specific need is related to DNS service: namely, in many cases, 30
seconds to establish a UDP session simply isn't enough time to permit
a reply to an outstanding DNS query.  I want to be able to up that
timeout to something closer to 60 or 120 seconds.)

-- 
James Ralston, Information Technology
Software Engineering Institute
Carnegie Mellon University, Pittsburgh, PA, USA

On 2002-10-31 at 21:12:36-0500 netfilter@interlinx.bc.ca wrote:

> There seems to be varied needs for netfilter specific /proc entries.
> The tcp-window-tracking patch seems to me to have placed a /proc
> entry point for netfilter most sanely at
> /proc/sys/net/ipv4/netfilter/.  I would also like to have a
> sysctl/proc node to diddle with tunables in my Amanda conntracking
> module.
> 
> Specifically the default of 180 seconds for a UDP stream is not long
> enough on the control (master in netfilter parlance) connection of
> an Amanda session, so I would like to override the master's timeout
> value in my conntrack helper.  I have tested my theory with a hard
> coded value and it work.  Now I would like to make it tunable by the
> user/administrator.
> 
> I suppose I could pass an argument while loading the module, but
> using sysctl (and/or /proc) just seems so much more sane.  But I
> digress, greatly.
> 
> I am wondering if Jozsef and/or Harald would like to separate out
> the creation of the /proc/sys/net/ipv4/netfilter/ node into a
> separate patch for the rest of us to use, rather than having to make
> tcp-window-tracking a prerequisite just to get a proc entry to use.
> 
> Thots?
> b.
