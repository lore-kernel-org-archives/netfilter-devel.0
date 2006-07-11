From: Simon Kirby <sim@netnation.com>
Subject: Excessive CPU use in find_appropriate_src()
Date: Tue, 11 Jul 2006 16:11:37 -0700
Message-ID: <20060711231137.GB9526@netnation.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
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

Hey all,

On a box set up to do LVS, we were seeing a CPU saturate (NAPI in full
force) with only about 6000 pps going through the box.  This was with
2.4.27, but 2.4.32 and 2.6.17 don't seem much different in the related
sections of code (apart from it looking much cleaner :) ).

The NAT mode of LVS depends on the netfilter NAT bits, so the related
conntrack stuff and nat modules were loaded.  oprofile showed 78% of
the CPU spent in find_appropriate_src(), which can be found in
net/ipv4/netfilter/ip_nat_core.c.

It appears the nat table size follows the conntrack size, so I tried
raising it from the default to 131072.  This made no noticeable
difference.  Eventually, I noticed that one host was taking more than
half of the entries in ip_conntrack (about 16,000 entries of 30,000),
and decided to try firewalling it by filtering in the PREROUTING chain of
the nat table.  This caused the load to drop to normal (almost nothing).

Further investigation shows that the host in question actually had no
rules set up on the box, but that they were in the configuration
previously and had set their gateway to go through the box that was
having the load problems.  This meant that routing was asymmetric and the
conntrack table was filling up with entries from the host that it only
saw one side of.

As far as I can tell, find_appropriate_src() is hashing on on
a source IP and protocol.  I don't see how it would ever sit there
linearly scanning a large hash bucket, though, as the first hash entry
should be enough to make it match and stop the walking.  It seems to be
hashed with (almost) the same conditions as the test, and 131072 buckets
should be enough(tm).

What am I missing here?

Simon-
