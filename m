From: Rob McMillen <rvmcmil@cablespeed.com>
Subject: Release of snort_inline-1.9.1
Date: Wed, 5 Mar 2003 06:36:58 -0500 (EST)
Sender: snort-devel-admin@lists.sourceforge.net
Message-ID: <Pine.LNX.4.44.0303050625220.1973-100000@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: snort-devel@sourceforge.net,  <snort-users@lists.sourceforge.net>,
     <netfilter-devel@lists.netfilter.org>,  <netfilter@lists.netfilter.org>
Return-path: <snort-devel-admin@lists.sourceforge.net>
To: honeypots@securityfocus.com,  <focus-ids@securityfocus.com>
Errors-To: snort-devel-admin@lists.sourceforge.net
List-Help: <mailto:snort-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:snort-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/snort-devel>,
	<mailto:snort-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/snort-devel>,
	<mailto:snort-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=snort-devel>
List-Id: netfilter-devel.vger.kernel.org


	On behalf of the Honeynet Project, I would like to announce the
release of snort_inline-1.9.1.  This version of snort_inline has been
updated to the latest version of Snort: 1.9.1, with a few
modifications.  You can download it at:

http://project.honeynet.org/papers/honeynet/tools/

        snort_inline takes packets from iptables instead of libpcap.  It
then uses new rule types to help iptables make pass or drop decisions
based on the snort rules format.  These new rule types consist of:

drop - The drop rule type will tell iptables to drop the packet and log it
via usual snort means.

reject - The reject rule type will tell iptables to drop the packet; log
it via usual snort means; and send a TCP reset if the protocol is TCP or
an icmp port unreachable if the protocol is UDP.

sdrop - The sdrop rule type will tell iptables to drop the packet.
Nothing is logged.

        To get you started, Mike Clark <mike@honeynet.org> has started a
drop ruleset to stop suspicious traffic from leaving a compromised
Honeypot.  A copy of this ruleset can be found in the rules directory of
the snort_inline-1.9.1 package, but the latest and greatest can always be
found at:

http://project.honeynet.org/papers/honeynet/tools/drop.rules

        Also, in order to ensure a drop rule has precedence over an alert
or log rule, the rule application order has been changed.  The
snort_inline-1.9.1 rule application order is:

->activation->dynamic->drop->sdrop->reject->alert->pass->log

Also, if you don't feel like downloading and compiling source code, take a
look at the HONEYNET SNORT_INLINE TOOLKIT.  This is a statically compiled
snort_inline-1.9.1 binary put together by the Honeynet Project for the
Linux Operating System.  It comes with a set of drop.rules, the
snort_inline binary, a snort-inline rotation shell script, and a good
README.  It can be found at:

http://www.honeynet.org/papers/honeynet/tools/

        For more details on installing, configuring, developing, and
running snort_inline-1.9.1, please read the doc/README.INLINE contained in
the package.

        Feel free to contact me at rvmcmil@cablespeed.com if you have any
questions, concerns, or gripes regarding snort_inline-1.9.1.

Rob McMillen
Member of the Honeynet Project



-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
