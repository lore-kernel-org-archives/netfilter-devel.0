From: "Feldman, Scott" <scott.feldman@intel.com>
Subject: RE: Extremely slow network with e1000 & ip_conntrack
Date: Thu, 4 Dec 2003 09:37:19 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <C6F5CF431189FA4CBAEC9E7DD5441E0102CBDD21@orsmsx402.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Harald Welte" <laforge@netfilter.org>,
	<netfilter-devel@lists.netfilter.org>,
	<linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@redhat.com>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
content-class: urn:content-classes:message
To: "Stephen Lee" <mukansai@emailplus.org>
List-Id: netfilter-devel.vger.kernel.org

> Is it not supported by the hardware?  Seems TSO could improve 
> performance a bit since the 1000/MT Desktop is starved for 
> PCI bandwidth at 32-bit/33MHz.

TSO is support on 82540.  Turning off TSO is a workaround, but what's
behind the dependency of TSO and ip_conntrack?  You indicated in an
earlier note that having the ip_conntrack module loaded was a factor.
Do you have a nic to try with tg3?  I believe tg3 has TSO enabled as
well (in 2.6.0-test11).

-scott
