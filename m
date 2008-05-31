From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] Release conntrack-tools 0.9.7
Date: Sat, 31 May 2008 18:46:56 +0200
Message-ID: <48418100.2080305@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020409010101010500060305"
Cc: netfilter-announce@lists.netfilter.org, lwn@lwn.net
To: netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020409010101010500060305
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project proudly presents another development release of
the conntrack-tools. This release includes important improvements, new
features and bugfixes:

* add ICMPv6 support (Krzysztof Oledzki)
* simplified conntrack update and deletion via command line
* major improvements in the state synchronization code
* add new best effort replication protocol

Detailed changelog is attached.

What are the conntrack-tools?

- The userspace daemon so-called conntrackd that covers the specific
aspects of stateful Linux firewalls to enable high availability
solutions. It can be used as statistics collector of the firewall use as
well. The daemon is highly configurable and easily extensible.

- The command line interface (CLI) conntrack that provides an interface
to add, delete and update flow entries, list current active flows in
plain text/XML, current IPv4 NAT'ed flows, reset counters, and flush the
complete connection tracking table among many other.

Where can I download it from?

http://www.netfilter.org/projects/conntrack-tools/downloads.html

Where can I get more information about them?

http://people.netfilter.org/pablo/conntrack-tools/

Enjoy,
	Pablo (on behalf of the Netfilter Project)

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers


--------------020409010101010500060305
Content-Type: text/plain;
 name="Changelog-cttols"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Changelog-cttols"

version 0.9.7 (2008/05/31)
--------------------------

o remove .svn directory from make distcheck tarballs (reported by B.Benjamini)
o fix minor compilation issue in amd64 with gcc4.3 (reported by Daniel Schepler)
o update manpages with the new URL: http://conntrack-tools.netfilter.org
o check for pkg-config at configure stage
o add flex version warning (better with >= 2.5.33)

= conntrack =
o fix minor compilation warning (Krzysztof Oledzki)
o add ICMPv6 (-p icmpv6) support (Krzysztof Oledzki)
o distinguish between invalid (unknown) and empty proto (Krzysztof Oledzki)
o simplify parameter-handling code
o check for missing source/address IP/ports in creation and get operations
o way more flexible conntrack updates and deletions
o fix NAT filtering via --src-nat and --dst-nat (reported by K.Oledzki)
o recover the ID support
o only allow the use of --secmark for listing (filtering)
o show display counters to stderr
o enable filtering by status and ID
o update manpage
o minor cleanups

= conntrackd =
o fix asymmetric path support (reported by Gary Richards)
o improve netlink overrun handling
o add more verbose error notification when we fail to inject a conntrack
o rework of the FT-FW approach
o minor fix of the manpage (Max Wilhelm)
o remove (misleading) counters and use information from the statistics mode
o use generic nfct_copy() from libnetfilter_conntrack to update objects
o use generic nfct_cmp() to compare objects
o improve network message sanity checkings
o add Mcast[Snd|Rcv]SocketBuffer clauses to tune multicast socket buffers
o add missing string.h required by strdup in config parsing
o add eventfd emulation to communicate receiver -> sender
o add best effort replication protocol (aka NOTRACK)
o rework the HELLO logic inside FT-FW
o fix leak in cache_destroy(): release objects before destroying the cache
o delay the closure of the dump descriptor to fix assertion with cache_wt

--------------020409010101010500060305--
