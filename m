From: Narendra K <Narendra_K@dell.com>
Subject: Re:[PROPOSAL]: Alias names for network interfaces
Date: Tue, 12 Jan 2010 13:49:56 -0600
Message-ID: <20100112194955.GA11752@mock.linuxdev.us.dell.com>
References: <EDA0A4495861324DA2618B4C45DCB3EE5899AC@blrx3m08.blr.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: be-mail2009@lina.inka.de, jengelh@medozas.de,
	net-tools@lina.inka.de, netfilter-devel@vger.kernel.org,
	jgarzik@users.sourceforge.net, charles_rose@dell.com,
	matt_domsch@dell.com, shyam_iyer@dell.com,
	jordan_hargrave@dell.com, sandeep_k_shandilya@dell.com
To: shemminger@linux-foundation.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:62015 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab0ALTt6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jan 2010 14:49:58 -0500
Content-Disposition: inline
In-Reply-To: <EDA0A4495861324DA2618B4C45DCB3EE5899AC@blrx3m08.blr.amer.dell.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> > > > > ifconfig would show Embedded_NIC_N instead of ethN.
> > > >
> > > > Renaming away from ethN causes some applications like net-snmp to
> > get
> > > > confused,
> > > > and others have special sorting rules based on existing model
> (like
> > > > quagga).
> > > >
> > > > I would argue that the "ethN" convention is part of existing
> system
> > > > ABI and should not get changed in a visible way to applications.
> > >
> > > Stephen,
> > >
> > > Thanks. What are your views on the current proposal we are making
> > where
> > > ethN names are not changed (or renamed) and libnetdevname would
> > suggest
> > > alias names for the ethN names ( and also alias to ethN names) in
> > user
> > > space. Applications like ip, ethtool etc can use these aliases, make
> > > calls to libnetdevname and get the ethN name.
> > >
> > > Libnetdevname would read from sysfs the smbios names of the network
> > > interface devices as Jordan mentioned
> > > (/sys/class/net/ethX/device/smbiosname). Would this be acceptable ?
> > 
> > I have no need or use for them, but if it doesn't break other things
> > then sure.
> 
> Jeff / netfilter-devel,
> 
> It would greatly help to know your views on this proposal.

The proposal is to enhance iptables (and other tools which might fail if
integrated port 1 does not get named as eth0) to support something like

iptables -A INPUT -i Embedded_NIC_1 -j ACCEPT 

in addition to what it already supports 

iptables -A INPUT -i eth0 -j ACCEPT.

Below is how the iptables code that handles the "-i ethN" would look
like (Only a part of the code to demonstrate the idea shown here) -

diff -Naru iptables-1.4.5/xtables.c iptables-1.4.5-new/xtables.c
--- iptables-1.4.5/xtables.c	2010-01-12 02:47:16.293249537 +0530
+++ iptables-1.4.5-new/xtables.c	2010-01-13 06:14:12.130185117 +0530
@@ -455,8 +455,8 @@
 void xtables_parse_interface(const char *arg, char *vianame,
 			     unsigned char *mask)
 {
-	int vialen = strlen(arg);
 	unsigned int i;
+	static char kernel_name[IFNAMSIZ];
 
 	memset(mask, 0, IFNAMSIZ);
 	memset(vianame, 0, IFNAMSIZ);
@@ -466,7 +466,11 @@
 			   "interface name `%s' must be shorter than IFNAMSIZ"
 			   " (%i)", arg, IFNAMSIZ-1);
 
-	strcpy(vianame, arg);
+	if (netdev_alias_to_kernel_name(arg, kernel_name) < 0)
+		show_alias_name_usage();
+	
+	strcpy(vianame, kernel_name);
+	int vialen = strlen(kernel_name);
 	if ((vialen == 0) || (vialen == 1 && vianame[0] == '+'))
 		memset(mask, 0, IFNAMSIZ);
 	else if (vianame[vialen - 1] == '+') {


where kernel_name is the ethN name that will be returned by a library
like libnetdevname which will map the user supplied "Embedded_NIC_1"
name to the corresponding ethN name, thus bringing in determinism while
referring to the network interfaces.

Netfilter-devel, would this be acceptable ?

With regards,
Narendra K

