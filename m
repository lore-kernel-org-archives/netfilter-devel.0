From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PROPOSAL]: Alias names for network interfaces
Date: Thu, 17 Dec 2009 15:48:02 +0100 (CET)
Message-ID: <alpine.LSU.2.01.0912171506130.5925@obet.zrqbmnf.qr>
References: <EDA0A4495861324DA2618B4C45DCB3EE5898BB@blrx3m08.blr.amer.dell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: net-tools@lina.inka.de, shemminger@osdl.org,
	netfilter-devel@vger.kernel.org, jgarzik@users.sourceforge.net,
	Matt_Domsch@Dell.com, Charles_Rose@Dell.com,
	Jordan_Hargrave@Dell.com, Sandeep_K_Shandilya@Dell.com
To: Narendra_K@Dell.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55053 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758612AbZLQOsJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Dec 2009 09:48:09 -0500
In-Reply-To: <EDA0A4495861324DA2618B4C45DCB3EE5898BB@blrx3m08.blr.amer.dell.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2009-12-17 14:54, Narendra_K@Dell.com wrote:

>We have been having discussions in the netdev list and
>anaconda-devel-list about creating multiple names for the network
>interfaces to bring determinism 
>into the way network interfaces are named in the OSes. In specific,
>"eth0 in the OS does not always map to the integrated NIC Gb1 as labeled
>on the chassis". This resulted in failures where user space expected the
>port with link up to be "eth0", which in many cases would not be the
>case. 
>For example, installers and firewall. 

I concur, with one exception: if, considering a single multi-port
card, I get interface names in reverse to what is printed on the
adapter. That looks like a manufacturer fail.

The firewall does not care. Just keep the name constant, which is
what udev's 70-persistent-net.rules already does.

>* Installer would provide options to the users to name the interfaces
>based on different naming conventions such as
>
>a)Chassis label - For Ex: Embedded_NIC_1[23..]
>b)Driver based names - For Ex: bce0, bce1 etc

As far as I can tell, all (Ethernet) driver names default
to ethX (or wlanX) only.

>For example - 
>
>/sbin/ifconfig Embedded_NIC_1
>/sbin/ip Embedded_NIC_N
>
>http://linux.dell.com/libnetdevname/patches/net-tools-1.60_libnetdevname
>.patch
>http://linux.dell.com/libnetdevname/patches/ethtool-6_libnetdevname.patc
>h
>http://linux.dell.com/libnetdevname/patches/iproute2-2.6.29_libnetdevnam
>e.patch )
>
>We would like to know the views of the upstream maintainers of the tools
>about this proposal.

The development of net-tools has long ceased (since 2001), except
that no one seems to notice and everybody still applies voltage to a
dead horse. It's only going to smell bad.
