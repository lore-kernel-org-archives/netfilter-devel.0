From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: information
Date: Sat, 3 Jul 2004 03:08:05 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0407030306001.22423-100000@filer.marasystems.com>
References: <200407021820.i62IKBMX017587@madinah.ccse.kfupm.edu.sa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "'Babar Qaisrani'" <baqb03@student.bth.se>,
   Netfilter List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
In-Reply-To: <200407021820.i62IKBMX017587@madinah.ccse.kfupm.edu.sa>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2 Jul 2004, Muhammad R. Sami wrote:

> I got the libipq/QUEUE part working but the problem is that it only works
> for the first time. For example, if I want to drop all icmp packets, it
> will, but if I change the nfmark from drop to accept and then recompile my
> libipq program, it does not work and the dropping policy is maintained. Same
> for the other way around. 

Please explain what you refer to by "change the nfmark from drop to 
accept".


nfmark does not have a concept of drop/accept, just value.



Is you perhaps speaking about the verdict set by the userspace telling if
the packet should be accepted (passed on to next hook) or dropped? This is
just a verdict and not related to nfmark.

Regards
Henrik
