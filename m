From: "Costa Tsaousis" <costa@tsaousis.gr>
Subject: iptables-save saves invalid negative --uid-owner expressions.
Date: Mon, 6 Jan 2003 03:31:07 +0200 (EET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <35565.195.97.5.193.1041816667.squirrel@fs.tsaousis.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-7
Content-Transfer-Encoding: 8bit
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

Hi all,

I believe I have faced another, not-mentioned-in-2002, bug:

If you setup negative owner expressions like this:

# a transparent cache for the machine running the cache
iptables -t nat -A OUTPUT \
    -m owner ! --uid-owner squid \
    -p tcp --dport 80 ! -d 127.0.0.1 \
    -j DNAT --to 127.0.0.1:3128

then iptables-save gives this:

-A OUTPUT -d ! 127.0.0.1 -p tcp -m owner --uid-owner !squid -m tcp --dport
80 -j DNAT --to-destination 127.0.0.1:3128

which produces a "user '!squid' not found" error when restored.

Kernel  : 2.4.18-19.8.0smp
iptables: 1.2.6a
Distro  : RedHat 8.0

Regards.

-- 
Costa Tsaousis

Author of
FireHOL (http://firehol.sf.net)
-------------------------------
An iptables stateful firewall generator,
that allows you to configure your firewall...
...the way you think of it!
