From: <Narendra_K@Dell.com>
Subject: [PROPOSAL]: Alias names for network interfaces
Date: Thu, 17 Dec 2009 19:24:29 +0530
Message-ID: <EDA0A4495861324DA2618B4C45DCB3EE5898BB@blrx3m08.blr.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Cc: <Matt_Domsch@Dell.com>, <Charles_Rose@Dell.com>,
	<Jordan_Hargrave@Dell.com>, <Sandeep_K_Shandilya@Dell.com>
To: <net-tools@lina.inka.de>, <shemminger@osdl.org>,
	<netfilter-devel@vger.kernel.org>, <jgarzik@users.sourceforge.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:52045 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbZLQOEZ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Dec 2009 09:04:25 -0500
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

[Please let me know if I have missed copying relevant list]

We have been having discussions in the netdev list and
anaconda-devel-list about creating multiple names for the network
interfaces to bring determinism 
into the way network interfaces are named in the OSes. In specific,
"eth0 in the OS does not always map to the integrated NIC Gb1 as labeled
on the chassis". This resulted in failures where user space expected the
port with link up to be "eth0", which in many cases would not be the
case. 
For example, installers and firewall. 

For more information on the issue please refer to
http://linux.dell.com/wiki/index.php/Oss/libnetdevname.

* For every network interface ethN, create a corresponding
/dev/net/ethN, which is a char device node, with minor number as the
interface index of the device.
And create symbolic links to this node under /dev/netdev/ such as
/dev/netdev/by-chassis-label/Embedded_NIC_1 which are based on smbios
names of the interfaces. 
Irrespective of what the OS names the port "Gb1" as,
/dev/netdev/by-chassis-label/Embedded_NIC_1 would always point to the
right interface with link up

http://linux.dell.com/wiki/index.php/Oss/libnetdevname#Proposal_1:

http://marc.info/?l=linux-netdev&m=125510301513312&w=2 - (Re: PATCH:
Network Device Naming mechanism and policy)
http://marc.info/?l=linux-netdev&m=125619338904322&w=2 - ([PATCH] udev:
create empty regular files to represent net)

It was suggested that an installer based approach be adopted

* Installer would provide options to the users to name the interfaces
based on different naming conventions such as

a)Chassis label - For Ex: Embedded_NIC_1[23..]
b)Driver based names - For Ex: bce0, bce1 etc

https://www.redhat.com/archives/anaconda-devel-list/2009-November/msg005
16.html
https://www.redhat.com/archives/anaconda-devel-list/2009-December/msg000
27.html

This was not favored too. These discussions resulted in a solution where
the alias names for network devices be implemented
completely in user space. In this solution libnetdevname would be
suggesting the alias names for network interfaces based on the bios
given
names for the interfaces. The bios names for the network interfaces are
available via smbios tables.

http://linux.dell.com/wiki/index.php/Oss/libnetdevname#Proposal_2


The solution would have below mentioned components - 


1. A library which would provide the following functionality.

    * Given an alias name, it would return the kernel name
    * Given a kernel name, provide a list of aliases
    * Tell us which alias is descriptive for a given kernel name, which
in this case will be Embedded_NIC_N 

2. User space tools like ifconfig, ip and iptables would support these
aliases such as Embedded_NIC_1 in addition to the ethN names.
These tools would call upon the library to map the Embedded_NIC_1 to a
ethN name. This would help bring in determinism in the way 
network interfaces are referred so that tools that expect determinism do
not fail.

For example - 

/sbin/ifconfig Embedded_NIC_1
/sbin/ip Embedded_NIC_N

Embedded_NIC_1 would always refer to the Integrated Port 1 on the system
Chassis labelled "Gb1" irrespective of how it is named by
the kernel and the library would provide this mapping. 


This solution would not need the kernel names of the network interfaces
(i.e ethN) to be changed. Here is how an example patch would 
look like - 

+	if (netdev_alias_to_kernel_name(alias_name,kernel_ifname) < 0) {
+                show_alias_name_usage();
+	}
+        strncpy(ifname, kernel_ifname, IFNAMSIZ);


where alias_name is "Embedded_NIC_N" and kernel name is ethN which is
returned by the library after it maps the bios given name to the 
kernel name of the network interface.( Here are some example patches for
ethtool, ip and net-tools which were written for char device node
solution. The patches to implement new proposal would look similar -

http://linux.dell.com/libnetdevname/patches/net-tools-1.60_libnetdevname
.patch
http://linux.dell.com/libnetdevname/patches/ethtool-6_libnetdevname.patc
h
http://linux.dell.com/libnetdevname/patches/iproute2-2.6.29_libnetdevnam
e.patch )


We would like to know the views of the upstream maintainers of the tools
about this proposal.

With regards,
Narendra K
Linux Engineering

