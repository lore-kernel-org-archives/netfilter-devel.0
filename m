From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: information
Date: Sat, 3 Jul 2004 14:16:48 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0407031415040.30357-100000@filer.marasystems.com>
References: <200407030911.i639B1MX025399@madinah.ccse.kfupm.edu.sa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "'Babar Qaisrani'" <baqb03@student.bth.se>,
   "'Netfilter List'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
In-Reply-To: <200407030911.i639B1MX025399@madinah.ccse.kfupm.edu.sa>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 3 Jul 2004, Muhammad R. Sami wrote:

> Now what I mean by "once" is that whenever I queue a specific flow of
> packet to the libipq program and for example set the verdict to DROP, it
> works fine. But if I change the verdict to ACCEPT and recompile my
> program, the box still drops the packets.

Have you restarted your application?

Are you positively sure you restarted the recompiled binary?

>From where are you invoking the QUEUE target?

What does your ruleset (in iptables) look like?

Regards
Henrik
