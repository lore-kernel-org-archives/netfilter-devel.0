From: Patrick Schaaf <bof@bof.de>
Subject: Re: Small profile of a fileserver
Date: Mon, 17 Mar 2003 22:59:08 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030317215907.GG15383@oknodo.bof.de>
References: <1047937471.1521.40.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1047937471.1521.40.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

HiHo,

> UP AMD Athlon XP 1600+ with gigE NIC. 256MB ddr ram.
> 307350492 total                                    208.7094
> 279059673 default_idle                             5813743.1875

Mightily overpowered. But that never Hertz :)

> 765178 ipt_do_table                             839.0110

Pet peeve: I assume you don't use any interface matches, right?
Could you try again with the horrible interface matching stuff
disabled inline in the kernel code? And then, could we please
devise a scheme to make those optional?

This is a bit of a wild guess, but what's in there besides that?

> 248488 __ip_conntrack_find                      862.8056

Tune the hashes, and that will improve, I think.

It is clearly interesting that lots of iptables is up there
above the base network stack, even though you describe your
tables as simple.

best regards
  Patrick
