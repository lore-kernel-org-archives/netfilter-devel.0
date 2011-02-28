From: xuhainanjing <xuhainanjing@126.com>
Subject: Re:[ANNOUNCE] conntrack-tools 0.9.15 released
Date: Mon, 28 Feb 2011 14:49:59 +0800 (CST)
Message-ID: <6e8339.919f.12e6b07d6ae.Coremail.xuhainanjing@126.com>
References: <4C3F5B9B.1050506@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	lwn@lwn.net, "Mohit Mehta" <mohit.mehta@vyatta.com>,
	netfilter-announce@lists.netfilter.org
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4C3F5B9B.1050506@netfilter.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

unsubscribe
At 2010-07-16 03:03:55=A3=AC"Pablo Neira Ayuso" <pablo@netfilter.org> w=
rote:
>Hi!
>
>The Netfilter project presents another development release of the
>conntrack-tools. This release includes:
>
>* IPv6-icmp fix for state synchronization.
>* Support for TCP window tracking (it requires a Linux >=3D 2.6.35).
>* Improvements and fixes for the NAT filtering support for the command
>line tool `conntrack'.
>* Patrick McHardy's conntrack zone support (See iptables' CT target).
>
>Among many others outstanding bugfixes. Specifically I'd like to thank
>Mohit Mehta from Vyatta for their prolific bug reporting and QA testin=
g.
>
>Please, see changelog attached for more details.
>
>Q: How stable are the conntrack-tools?
>A: The daemon that allows to synchronize states between firewalls has
>been tested in a cluster environment composed of two stateful firewall=
s
>running Debian 5.0 (Lenny) with a Linux kernel 2.6.32, keepalived
>1.1.15, using conntrackd in FT-FW mode. The test consisted of
>downloading the Linux kernel source code in a tarball file via HTTP an=
d
>randomly (in periods of 10 seconds) unplugging cablelinks to force the
>fail-over between the nodes. The results has shown no hangs/closure in
>any TCP connection.
>
>Q: What are the conntrack-tools?
>A: The conntrack-tools are:
>
>- The userspace daemon so-called conntrackd that covers the specific
>aspects of stateful Linux firewalls to enable high availability
>solutions. It can be used as statistics collector of the firewall use =
as
>well. The daemon is highly configurable and easily extensible.
>
>- The command line interface (CLI) conntrack that provides an interfac=
e
>to add, delete and update flow entries, list current active flows in
>plain text/XML, current IPv4 NAT'ed flows, reset counters, and flush t=
he
>complete connection tracking table among many other.
>
>Q: Where can I download it from?
>A: http://www.netfilter.org/projects/conntrack-tools/downloads.html
>
>Q: Where can I get more information about them?
>A: http://conntrack-tools.netfilter.org
>
>Q: Where can I have a look at the user manual?
>A: http://conntrack-tools.netfilter.org/manual.html
>
>On behalf of the Netfilter Core Team,
>Pablo.
>

