From: Chris Wilson <chris@netservers.co.uk>
Subject: MAC/IP pair match submission
Date: Thu, 8 Apr 2004 14:51:50 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404081333110.29813-100000@chris.camcom.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all,

I would like to submit a new IPtables match, developed by Netservers, for 
inclusion into the main IPtables tree.

The new match is called "macmatch" because it matches against a
(potentially very large) list of MAC/IP/Device triples, using a hash
table. This is much more efficient (faster to match) than having thousands
of rules like:

	"--mac-source MAC -s IP -i DEV"

It also leads to shorter ruleset loading times, and allows triples to be
added or removed from the list without modifying any iptables rules.

I have tried to get the patch into a format suitable for POM, using
Rusty's NEWPATCHES guide, but I couldn't figure out what to do with the
user-space part, so I've just included libipt_macmatch.c and
.macmatch-test as simple files in my distribution tarball.

You can find the code at
[http://www.netservers.co.uk/gpl/macmatch.tar.gz]. Comments are very
welcome. Please let me know if anything stands in the way of its
integration into IPtables and POM.

It does have some known bugs, but the most serious (system instability)
has only been observed when debugging is explicitly turned on. Please read
the BUGS section of macmatch.patch.help for details.

Cheers, Chris.
-- 
_  __ __     _
 / __/ / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_  ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\__/_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
