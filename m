From: Min Li <li9@expert.ics.purdue.edu>
Subject: xdmcp
Date: Mon, 4 Nov 2002 05:39:22 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.GSO.4.44.0211040539070.4935-100000@expert.ics.purdue.edu>
References: <20021104101704.GF3894@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@lists.netfilter.org, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <20021104101704.GF3894@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dear all,
I am trying to make xdmcp work on red-hat 7.3. What I did was turn on the
flag in /etc/kde/kdm/kdmrc, make "enable = true", since I'm using kde.
However, my exceed on the windows still cannot see the broadcast from the
linux machine. Please advise. Thanks a lot. I also checked the firewall
rules in /etc/sysconfig/iptables, and make sure port 177 is not blocked.

Min
