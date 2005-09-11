From: Patrick McHardy <kaber@trash.net>
Subject: MASQUERADE + DHCP problem
Date: Sun, 11 Sep 2005 17:07:18 +0200
Message-ID: <43244826.5020405@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

in 2.6.13 I removed this part from MASQUERADE to get more consistency
in source address selection:

-	/* FIXME: For the moment, don't do local packets, breaks
-	   testsuite for 2.3.49 --RR */
-	if ((*pskb)->sk)
-		return NF_ACCEPT;
-

Unfortunately this broke pump, it uses a regular UDP socket for
DHCP requests while no IP address is configured and fails in
MASQUERADE because no IP can be found. I'm not much in favour
of putting the check back in, so I want to discuss other
possiblities to keep pump working.

So far what's come to my mind is:
1) Tell users not to masquerade DHCP queries - makes most sense
   in my opinion, but breaks existing setups
2) Add a special hack to masquerade to handle DHCP while no
   local address exists by looking at the port and src/dst
   address. Incredibly ugly and wrong :)
3) Combination of the above - add the hack and print a warning
   to tell users to fix their ruleset, remove the hack after
   6 month

None of them is perfect, any other suggestions are welcome.
