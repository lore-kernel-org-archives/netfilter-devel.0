From: <Narendra_K@Dell.com>
Subject: RE: [PROPOSAL]: Alias names for network interfaces
Date: Wed, 13 Jan 2010 12:17:16 +0530
Message-ID: <EDA0A4495861324DA2618B4C45DCB3EE5899B5@blrx3m08.blr.amer.dell.com>
References: <EDA0A4495861324DA2618B4C45DCB3EE5899AC@blrx3m08.blr.amer.dell.com> <20100112194955.GA11752@mock.linuxdev.us.dell.com> <alpine.LSU.2.01.1001130039020.4567@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Cc: <shemminger@linux-foundation.org>, <be-mail2009@lina.inka.de>,
	<net-tools@lina.inka.de>, <netfilter-devel@vger.kernel.org>,
	<jgarzik@users.sourceforge.net>, <Charles_Rose@Dell.com>,
	<Matt_Domsch@Dell.com>, <Shyam_Iyer@Dell.com>,
	<Jordan_Hargrave@Dell.com>, <Sandeep_K_Shandilya@Dell.com>
To: <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:13881 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab0AMGrW convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2010 01:47:22 -0500
Content-class: urn:content-classes:message
In-Reply-To: <alpine.LSU.2.01.1001130039020.4567@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> On Tuesday 2010-01-12 20:49, Narendra K wrote:
> >
> >The proposal is to enhance iptables (and other tools which might fail
> if
> >integrated port 1 does not get named as eth0) to support something
> like
> >[...]
> >Below is how the iptables code that handles the "-i ethN" would look
> >like (Only a part of the code to demonstrate the idea shown here) -
> >
> >diff -Naru iptables-1.4.5/xtables.c iptables-1.4.5-new/xtables.c
> >--- iptables-1.4.5/xtables.c	2010-01-12 02:47:16.293249537 +0530
> >+++ iptables-1.4.5-new/xtables.c	2010-01-13 06:14:12.130185117
+0530
> >@@ -455,8 +455,8 @@
> > void xtables_parse_interface(const char *arg, char *vianame,
> > 			     unsigned char *mask)
> > {
> >-	int vialen = strlen(arg);
> > 	unsigned int i;
> >+	static char kernel_name[IFNAMSIZ];
> >
> > 	memset(mask, 0, IFNAMSIZ);
> > 	memset(vianame, 0, IFNAMSIZ);
> >@@ -466,7 +466,11 @@
> > 			   "interface name `%s' must be shorter than
> IFNAMSIZ"
> > 			   " (%i)", arg, IFNAMSIZ-1);
> >
> >-	strcpy(vianame, arg);
> >+	if (netdev_alias_to_kernel_name(arg, kernel_name) < 0)
> >+		show_alias_name_usage();
> >+
> >+	strcpy(vianame, kernel_name);
> >+	int vialen = strlen(kernel_name);
> > 	if ((vialen == 0) || (vialen == 1 && vianame[0] == '+'))
> > 		memset(mask, 0, IFNAMSIZ);
> > 	else if (vianame[vialen - 1] == '+') {
> 
> That code, even if snippet, needs more work.
> 
> (iptables is not too great on multithread safety, but do we have to
> make it worse by adding static buffers? And unchecked strcpy, what
> should BPF think of us?)
> 

Thanks. Sure, I would address these concerns.

> >where kernel_name is the ethN name that will be returned by a library
> >like libnetdevname which will map the user supplied "Embedded_NIC_1"
> >name to the corresponding ethN name, thus bringing in determinism
> while
> >referring to the network interfaces.
> >
> >Netfilter-devel, would this be acceptable ?
> 
> I tried to look at libnetdevname. There is a gitweb, but no
> git-clone. I think that they library should possibly use netlink
> and libtool. And other remarks.

I would look into why git clone isn't working. Please find the latest
libnetdevname tar file here -
http://linux.dell.com/libnetdevname/permalink/
The implementation is for char device node solution we proposed earlier.
It would be extended to handle the current proposal if it is acceptable.

With regards,
Narendra K
