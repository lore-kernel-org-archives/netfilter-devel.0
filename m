From: "Gil Shai" <GilS@GoNetworks.com>
Subject: RE: Changing the Ethernet header
Date: Thu, 17 Feb 2005 12:31:28 +0200
Message-ID: <7DC268DDBA95E14D8572DF824F92789E03EE5D@gn-ex01.Go80211.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Content-class: urn:content-classes:message
To: "Patrick Schaaf" <bof@bof.de>
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

I am trying to create a rule that causes packets going to a certain IP
to have a certain VLAN header.
That is what I'm trying to do basically and I'm trying to use the
iptables for it although I know it wasn't meant for it.

Thanks,
Gil

-----Original Message-----
From: Patrick Schaaf [mailto:bof@bof.de]=20
Sent: Thursday, February 17, 2005 10:34 AM
To: Gil Shai
Cc: netfilter-devel@lists.netfilter.org
Subject: Re: Changing the Ethernet header

> Anyone has ideas as to why or what are the possible reasons to this=20
> phenomenon?

You are messing with stuff that is not to be messed with. iptables
operates at a layer above Ethernet, and THE KERNEL (the core network
stack's destination, neighbour, and hard header cache components),
manages the ethernet headers.

There is a fullblown VLAN support infrastructure in the kernel.
What are you trying to do, that cannot be done using that
infrastructure?

best regards
  Patrick
