From: Michael Bellion and Thomas Heinz <nf@hipac.org>
Subject: [ANNOUNCE] nf-hipac v0.8 released
Date: Wed, 25 Jun 2003 22:12:49 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200306252212.49588.nf@hipac.org>
Reply-To: nf@hipac.org
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi

We have just released a new version of nf-hipac. You might wonder why
this lasted so long. Well, we did a major rewrite of most of the code,
added a bunch of new features and did heavy userspace testing of the
algorithmic core. 


For all of you who don't know nf-hipac yet, here is a short overview:

nf-hipac is a drop-in replacement for the iptables packet filtering module.
It implements a novel framework for packet classification which uses an
advanced algorithm to reduce the number of memory lookups per packet.
The module is ideal for environments where large rulesets and/or high
bandwidth networks are involved. Its userspace tool, which is also called 
'nf-hipac', is designed to be as compatible as possible to 'iptables -t 
filter'.

The official project web page is:    http://www.hipac.org
The releases can be downloaded from: http://sourceforge.net/projects/nf-hipac


Here is a short overview of the new features:

  - generic support for iptables targets and matches:
       nf-hipac is now binary compatible to iptables targets and
       matches.

  - support for user defined chains:
       This was a real challenge.

  - 64 bit atomic counters:
       We avoided cache ping-pong on SMP machines.

  - nf-hipac connection tracking helper:
       This is basically a dummy module which avoids that you
       manually load ip_conntrack.

  - extended proc statistics

  - libnfhipac:
       We've implemented a very lightweight userspace library which
       does the netlink communication for you, so writing an alternative
       userspace tool for nf-hipac is simplified. [you still have to
       construct the rule which is sent to the kernel]

  - new netlink based protocol:
       Apart from that it was necessary to redesign the protocol
       to support the new features we have improved the listing speed
       by putting as many rules/chains in a packet as possible.

 - non-terminal rule support:
       The nf-hipac rule target is optional.

Basically, nf-hipac now offers the same functionality as iptables -t filter
apart from the RETURN target which is missing and some minor
user-defined chain related issues.

Unfortunately we discovered an alignment bug in the btree layer
(the only part we haven't rewritten) which breaks architectures
requiring strict alignment for pointers (like alpha).
Sparc64 again seems to work fine.


Enjoy,

+-----------------------+----------------------+
|   Michael Bellion     |     Thomas Heinz     |
| <mbellion@hipac.org>  |  <creatix@hipac.org> |
+-----------------------+----------------------+
