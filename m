From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/6] conntrack: get rid of per-object timer
Date: Fri, 19 Aug 2016 13:36:09 +0200
Message-ID: <1471606575-2197-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56072 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751817AbcHSLf5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Aug 2016 07:35:57 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

During NFWS 2016 it was mentioned that per-conntrack timers have
two drawbacks:
 - the 5-day default established timeout is very large and brings
   extra constraints for the timer subsystem.
 - most distros enable timer stats so timer struct eats 80 bytes
   in each conntrack object.

This series replaces the per-object struct timer with a u32 jiffie
stamp and one global delayed work queue for conntrack eviction.
Size of nf_conn struct is reduced to 256 bytes on x86_64.

Eviction is performed from the packet path when doing
table lookup, for cases where we have idle periods the work
queue is used.

Tested with following script, conntrackd running in 'relible
event mode' and httpterm running on other host:

-----------------------------------------------------------
random_resize() {
        while true; do
                RND=$RANDOM%256000
                RND=$((RND+8192))
                sysctl net.netfilter.nf_conntrack_buckets=$RND
                sleep $((RANDOM % 120))
        done
}

random_flush() {
        while true; do
                sleep $((RANDOM % 120))
                conntrack -F
        done
}

random_startstop() {
        while true; do
                sleep $((RANDOM % 120))
                pkill -STOP conntrackd
                sleep $((RANDOM % 10))
                pkill -CONT conntrackd
        done
}

http-client -u 1000 -t 3 -F 192.168.10.50 -G 192.168.10.17:8001 &
http-client -u 1000 -t 3 -F 192.168.10.51 -G 192.168.10.17:8001 &
http-client -u 1000 -t 3 -F 192.168.10.52 -G 192.168.10.17:8001 &

random_resize &
random_flush &
random_startstop &

wait
-----------------------------------------------------------

 include/net/netfilter/nf_conntrack.h        |   36 +++--
 include/net/netfilter/nf_conntrack_ecache.h |   17 +-
 net/netfilter/nf_conntrack_core.c           |  186 ++++++++++++++++++++--------
 net/netfilter/nf_conntrack_ecache.c         |   22 ++-
 net/netfilter/nf_conntrack_netlink.c        |   39 ++++-
 net/netfilter/nf_conntrack_pptp.c           |    3 
 net/netfilter/nf_nat_core.c                 |    6 
 7 files changed, 215 insertions(+), 94 deletions(-)
