From: Scott MacKay <scottmackay@yahoo.com>
Subject: Re: pre, pre, premangle?
Date: Thu, 24 Apr 2003 08:30:05 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030424153005.69162.qmail@web13907.mail.yahoo.com>
References: <1051195490.5930.35.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <1051195490.5930.35.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Actually, my goal is to mangle packet contents before
conn track gets its hands on it.  I currently do some
packet mangling as part of a PREROUTING userspace
queue (QUEUE), but I think my mangling is occuring
after conn track has already looked at the contents
(actually the problem is that the packet comes in
'mangled' and my stuff demangles it.  I think conn
track is building its assumptions on the mangled
packet contents).
Using this patch as a base, do you believe I could add
in QUEUE as a target?  If so, is there any way to
identify which table a userspace module is getting the
packet from?  I see ipq_packet_msg has a hook field,
but never saw any apps use it.  Since I still need to
do processing at the mangle PREROUTING (or INPUT &
FORWARD) stages and there can be only 1 QUEUE target,
I would probably need to differentiate between a raw
and mangle table...Thanks for the info so far tho!

-Scott


--- Martin Josefsson <gandalf@wlug.westbo.se> wrote:
> On Thu, 2003-04-24 at 16:16, Scott MacKay wrote:
> > Hiyas, 
> >     Is there any way to hook into incoming packets
> > such that you get it before any other
> investigative
> > code (such as conn tracking), examine it, and
> mangle
> > it before letting them work on the packet?
> 
> ./runme --batch pending
> ./runme userspace/raw.patch
> 
> iptables -t raw -A PREROUTING yada yada
> 
> Many of the targets that mangle packets have checks
> for which table they
> are beeing added too and refuse to be added to other
> tables than mangle.
> So to be able to use them in the raw table you will
> have to modify them
> a bit. The raw table is mostly used for DROP-ing,
> NOTRACK-ing and
> TRACE-ing packets.
> 
> userspace/raw.patch tries to patch the userspace
> iptables as well.
> 
> -- 
> /Martin


__________________________________________________
Do you Yahoo!?
The New Yahoo! Search - Faster. Easier. Bingo
http://search.yahoo.com
