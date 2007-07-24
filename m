From: "Indan Zupancic" <indan@nul.nu>
Subject: 2.6.23-rc1: ipv4_get_l4proto: Frag of proto 17
Date: Wed, 25 Jul 2007 01:24:27 +0200 (CEST)
Message-ID: <56054.81.207.0.53.1185319467.squirrel@secure.samage.net>
Mime-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hello,

After reading the "Never happen" comment in the code, I thought it
wasn't too silly to mention that it apparently does happen. Never saw
the message before, hence this mail. This happened on a machine
doing SNAT for another pc, so conntrack may be involved.

The three errors happen within 1.5 seconds of each other:

[17834.377955] ipv4_get_l4proto: Frag of proto 17
[17835.358985] ipv4_get_l4proto: Frag of proto 17
[17835.872457] ipv4_get_l4proto: Frag of proto 17

As this seems to be an incident, I've no idea how to debug it, nor
whether it's worth debugging. If this can be caused by a peer
sending a bad packet I'd ignore this report.

If this is serious enough to be reported, perhaps it should be a BUG?

Greetings,

Indan


P.S. Netfilter's bugzilla gives an error when the search function is used.
