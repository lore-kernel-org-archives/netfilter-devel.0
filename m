From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: ip_conntrack performance issues - also semantic issues
Date: 19 Jan 2003 10:40:47 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1042969247.28675.57.camel@tux.rsn.bth.se>
References: <20030118232752.26497.32589.Mailman@kashyyyk>
	 <15914.20503.476455.344137@isis.cs3-inc.com>
	 <20030119075102.GF12401@oknodo.bof.de>
	 <15914.25470.189261.168220@isis.cs3-inc.com>
	 <20030119091656.GG12401@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Don Cohen <don-netf@isis.cs3-inc.com>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20030119091656.GG12401@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 2003-01-19 at 10:16, Patrick Schaaf wrote:

> >  > 1) that a NEW conntrack need not be allocated in full.
> > I guess you're saying that the allocation takes a significant amount
> > of time, entering into hash is another chunk, and the first part is
> > done at prerouting.
> 
> I'm pretty sure that the allocation is the main cost, putting into
> the hashes is not performance critical per se (if the lists are short). 

My small unscientific tests (performed quite some time ago) say that the
allocation isn't the most costly operation performed.
The test was a simple SYN-flood (random source ip's and ports) beeing
forwarded by a router. If I didn't load ip_conntrack at all everything
was fine and I had lots of cpu left. When I loaded ip_conntrack the cpu
usage went to 100%. Then I tried blocking the flood in filter/FORWARD
and that helped _a lot_ and in this case the allocation is still
happening for each packet. But of course blocking it in raw/PREROUTING
is even better (before the packets reach ip_conntrack)

My point is that until someone really profiles ip_conntrack I'm not sure
I'll believe that the allocation is the most costly operation.
We need good profiles for a lot of diffrent situations.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat you with experience.
