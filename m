From: Christian Hammers <ch@westend.com>
Subject: Asym. router has problems with full ip_conntrack table in 2.4.20
Date: Mon, 27 Jan 2003 12:26:53 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030127112653.GB9209@westend.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hello

I use kernel 2.4.20 and iptables filter (no NAT or stateful filtering!) on
a router that is part of a large network and has many asymetric routes
i.e. inbound packages of some connections go over this host but replies
are send via another router. Therefore stateful packet filtering would
have no chance to get some kind of ESTABLISHED state or similar and is
completely disabled.

Now sadly the /proc/net/ip_conntrack still exists and slowly fills up,
which leads to the following message after a while of uptime:

	ip_conntrack: table full, dropping packet.

The /proc/sys/net/ipv4/ip_conntrack_max exists, too. 
I can play around with it but even "-1" or "0" do not seem to disable the
table, nor to flush it.
I have reboodet the maching already.
lsmod shows only the following (relevant), ipt_conntrack.o is
at least compiled and installed in /lib/modules/* although not loaded.
	ipt_MARK                 800   0  (autoclean)
	iptable_mangle          2208   0  (autoclean)
	ipt_LOG                 3200   2  (autoclean)
	iptable_filter          1760   1  (autoclean)
	ip_tables              13184   4  [ipt_MARK iptable_mangle ipt_LOG iptable_filter]

I currently have:
	lx01:/home/ch# wc -l /proc/net/ip_conntrack 
	  25963 /proc/net/ip_conntrack
(all normal traffic, 99% in state [UNREPLIED] due to asymetric routing)
	
I can reproduce on my desktop machine that the /proc files are active
without having ipt_conntrack.o loaded and that I really have packet loss
when the tables fill up!

TIA & bye,

-christian-

-- 
Christian Hammers             WESTEND GmbH  |  Internet-Business-Provider
Technik                       CISCO Systems Partner - Authorized Reseller
                              Lütticher Strasse 10     Tel 0241/701333-11
ch@westend.com                D-52064 Aachen              Fax 0241/911879
