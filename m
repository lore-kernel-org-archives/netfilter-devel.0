From: Patrick Schaaf <bof@bof.de>
Subject: Re: linux packet forwarding rate
Date: Thu, 6 Mar 2003 08:13:36 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030306071336.GE2829@oknodo.bof.de>
References: <3E66F084.3F396F59@ie.cuhk.edu.hk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philip Ho <cbho@ie.cuhk.edu.hk>
Content-Disposition: inline
In-Reply-To: <3E66F084.3F396F59@ie.cuhk.edu.hk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Mar 06, 2003 at 02:53:56PM +0800, Philip Ho wrote:
> Dear all
> 
> I want to forward 1Gbps at line rate. Has anyone successfully used linux
> to forward 1Gbps (assuming 1500 byte packet length, that is equivalent
> to 80kpps) on gigabit ethernet?

Please ask again on a more suitable mailing list. The question has
nothing to do with further development of iptables / netfilter.
A suitable list may be:

http://www.uwsg.iu.edu/hypermail/linux/net/

Nevertheless, I'm sure the S/390, PowerPC, Sparc, Alpha, and HP/UX ports
managed that for some years, now. Also high end four- and eight-processor
x86 systems, may have made it.

BTW, with line rate, one usually means the absolute worst case line
rate with SMALL packets. Also, Ethernet is full duplex nowadays,
so the line rate of a single GE interface, at 2gbit/s, with 64 byte
packets, would be roughly 4000000 (4 million) packets per second.

On a (dual) Pentium-III 800Mhz system, on a 64/66 Mhz bus, I was able, about
two years ago, to push slightly more than 700mbit/s (synthetic UDP)
with jumbo frames, and I vaguely remember about 50000 packets per
second a processing ceiling.

Finally, the ONLY way to REALLY find out about these things, is to
get some hardware, test software, UNDERSTAND WHAT IS TESTED, and
the TEST!

Oh, and on 99% of real life linux servers, it just doesn't matter at all.

best regards
  Patrick
