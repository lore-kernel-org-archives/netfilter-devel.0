From: Nick Eggleston <netfilter-devel@nick.corplink.net>
Subject: conntrack state change logging
Date: Thu, 5 Sep 2002 11:07:34 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0209051100260.3007-100000@strut.corplink.net>
References: <20020620211242.V2543@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.samba.org>
In-Reply-To: <20020620211242.V2543@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Is there a framework for logging activity in the conntrack database?

For example, I might want a log entry generated when:

* a new entry is added
* an entry is removed normally (standard tcp fin removal)
* an entry is timed-out
* state of an entry is changed

or course, i would want to be able to filter based on regular iptables
expressions, like source address, port destination address, port etc.

One application of this would be to create log entries for tcp connections
to a certain port, which would capture session length, bytes and packets
for each session.

Can this be done easily?

Thanks,

Nick

-- 
Nick Eggleston
Consultant
Data Communications Consulting, Inc.
6320 Rucker Road, Suite E
Indianapolis, IN  46220
317/726-0295 x18
317/202-2445 (fax)
