From: "Gil Shai" <GilS@GoNetworks.com>
Subject: Changing the Ethernet header
Date: Thu, 17 Feb 2005 09:14:20 +0200
Message-ID: <7DC268DDBA95E14D8572DF824F92789E03EE2B@gn-ex01.Go80211.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
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

Hi,

I am writing a target module for iptables on a Debian kernel 2.6.9
In the target function, when I get the sk_buf, I change the Ethernet
header and add to it a VLAN header.

However, when I sniff the packets that are sent, they do not contain the
VLAN header.

Anyone has ideas as to why or what are the possible reasons to this
phenomenon?

Thanks,
Gil
