From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [RFC] Die to NOTRACK/TRACE, long live MARK!
Date: Wed, 19 May 2004 23:30:23 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405192236590.3749-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Willy Tarreau suggested that the TCP window tracking code could be used to
protect connections against the "TCP vulnerabilities" brought up recently
(see for example http://www.uniras.gov.uk/vuls/2004/236929). After some
discussion and code-fragments the result is that it could be done fairly
easily: the SYN/RST probes could be counted and when a threshold is
reached, we'd deliberately drop in-window SYN/RST segments to protect the
connection. However, it'd then mean a violation of the TCP protocol
specification and therefore I'd definitely not like to enable it by
default or to enable it for all traffic. So there should be a way to tell
the system which connections (packets) to protect.

We could introduce a new silly target for that purpose like NOTRACK or
TRACE. However it's pure marking and we do have a interface to mark
packets: the MARK target. So if we could tell the system which mark value
has got the given special meaning, we wouldn't need a new target and we
could even eliminate the NOTRACK/TRACE targets.

Such natural way could be to use the proc interface. Say the files
"mark_notrack", "mark_trace", "mark_syn_rst_protection" in
/proc/sys/net/ipv4/netfilter/ could store the mark values which'd enable
the given functionality for the marked packets. Even the symbolic names
could be supported, say

	... -j MARK --set-mark syn_rst_protection

It seems more natural and what is much more important, extendable anytime
without blowing up the system.

Is there any flawn in the plan? I think NOTRACK/TRACE is not rooted
yet deeply so it won't be painful to get rid of them :-).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
