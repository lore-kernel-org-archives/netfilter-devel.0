From: Willy Tarreau <willy@w.ods.org>
Subject: Re: Status of benchmarking tool?
Date: Tue, 20 Jan 2004 22:49:25 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040120214925.GA10961@alpha.home.local>
References: <96D13222E704DC4D868F0009F0EE53E11E4165@orsmsx410.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Accardi, Kristen C" <kristen.c.accardi@intel.com>
Content-Disposition: inline
In-Reply-To: <96D13222E704DC4D868F0009F0EE53E11E4165@orsmsx410.jf.intel.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Mon, Jan 19, 2004 at 03:47:37PM -0800, Accardi, Kristen C wrote:
> I haven't been able to find an standard plan, and it seems that many
> performance numbers I see are for extremely simple rulesets.  Perhaps I
> am just looking in the wrong places, so if anyone can educate me about
> what the "standard" benchmark used for packet filtering is, I would
> appreciate it.

Benchmark is always problematic because it must represent YOUR usage.
Many people have different constraints regarding Netfilter, and will test it
in different ways. The first ones which come to mind :
  - number of sessions/s vs # of active sessions
  - number of sessions/s vs # of rules
  - number of packets/s (or even rules/s) for stateless filtering
  - resistance to sustained high loads
  - logging capacity (# of lines/s)
  - time taken by the load of large filtering policies during idle and load
  - behaviour in presence of complex protocols or rules,
  ...

I have personnally done extensive tests on 1-5, and for this I used an old
home-made HTTP injecter coupled with Tux. And to generate lots of rules (I
didn't need many anyway), shell script + iptables-restore were fine. To
measure the number of packets per second, it's very easy to reduce your MTU
between an FTP client and an FTP server.

There are lots of simple tricks like this with tiny tools. You often also have
to tune the external components to get a little reliability in the tests, and
that's almost all. Perhaps it would be interesting to maintain a "firewall
stress toolbox" ? I've been using these tools for years on diskettes first,
then CD and USB keys, so that any PC can become part of a test platform.

Cheers,
Willy
