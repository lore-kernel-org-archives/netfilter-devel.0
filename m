From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Extremely slow network with e1000 & ip_conntrack
Date: Thu, 11 Dec 2003 09:25:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0312110921540.23401-100000@filer.marasystems.com>
References: <20031211072608.GF22826@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "David S. Miller" <davem@redhat.com>,
	Stephen Lee <mukansai@emailplus.org>,
	<scott.feldman@intel.com>, <netfilter-devel@lists.netfilter.org>,
	<linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031211072608.GF22826@sunbeam.de.gnumonks.org>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 11 Dec 2003, Harald Welte wrote:

> yes, this is certainly a problem - but not with conntrack, only with
> nat.  So maybe we should add a safeguard, preventing
> iptables_nat/ipchains/ipfwadm from being loaded when TSO on any
> interface is enabled?  Or at least print a warining in syslog?

TSO can be enabled while NAT is running so you better do this in the 
packet flow or if there is a suitable notifier hook that can be used.

Most firewalls etc load the ruleset before activating the 
interfaces, i..e before even loading the nic drivers, so there is no 
interfaces to look at when iptables_nat is loaded.

Regards
Henrik
