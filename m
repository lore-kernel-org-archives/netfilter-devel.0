From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: ICMP match bug
Date: Mon, 3 Feb 2003 14:20:20 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030203132020.GB17330@balabit.hu>
References: <20030127140143.GA29965@balabit.hu> <20030127173937.GB31017@balabit.hu> <20030131120016.GY9073@naboo.cybercafe42>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Content-Disposition: inline
In-Reply-To: <20030131120016.GY9073@naboo.cybercafe42>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jan 31, 2003 at 01:00:16PM +0100, Harald Welte wrote:
> On Mon, Jan 27, 2003 at 06:39:37PM +0100, Balazs Scheidler wrote:
> > Let me fix myself, the latest iptables version seems to have this demand
> > loading fixed, thus our problem is solved. 
> 
> ;).  Yes, I remember having fixed that demandloading code.  It now has
> more comment than C code :(
> 
> > However the way the icmp match defaults does not seem to be correct to me.
> 
> I totally agree.  Any suggestions?

I don't think this issue can be fixed without changing the userspace API
(and retain compatibility)

Incompatible solutions:

1) have a special value meaning "no icmp type specified", for example -1 (0xFF)
   would mean "any"
2) create a possibility to match a range of icmp types, and initialize the
   range to [0,max_icmp_type]
3) use a bitmask instead of a range where each bit would mean a specific
   icmp type

Option 1) could be implemented without changing the size of the match
struct, the other two would involve changing the size of the match struct.

I've checked the kernel source, specifying -1 for old kernels would mean
'match nothing', thus our beloved compatibility equations would be like
this:

1) old kernel - new iptables

when ANY icmp type is specified, no packets would be matched, this is
different from the current behaviour when icmp type 0 is matched (PONG).

when a usual icmp type is specified everything works correctly.

2) new kernel - old iptables

no problem.

The question is whether we can live with the incompatibility of matching
nothing instead of PONG when no --icmp-type is specified.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
