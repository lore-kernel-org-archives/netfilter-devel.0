From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re:[PROPOSAL]: Alias names for network interfaces
Date: Wed, 13 Jan 2010 01:11:41 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1001130039020.4567@obet.zrqbmnf.qr>
References: <EDA0A4495861324DA2618B4C45DCB3EE5899AC@blrx3m08.blr.amer.dell.com> <20100112194955.GA11752@mock.linuxdev.us.dell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: shemminger@linux-foundation.org, be-mail2009@lina.inka.de,
	net-tools@lina.inka.de, netfilter-devel@vger.kernel.org,
	jgarzik@users.sourceforge.net, charles_rose@dell.com,
	matt_domsch@dell.com, shyam_iyer@dell.com,
	jordan_hargrave@dell.com, sandeep_k_shandilya@dell.com
To: Narendra K <Narendra_K@dell.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:33519 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab0AMALm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jan 2010 19:11:42 -0500
In-Reply-To: <20100112194955.GA11752@mock.linuxdev.us.dell.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-01-12 20:49, Narendra K wrote:
>
>The proposal is to enhance iptables (and other tools which might fail if
>integrated port 1 does not get named as eth0) to support something like
>[...]
>Below is how the iptables code that handles the "-i ethN" would look
>like (Only a part of the code to demonstrate the idea shown here) -
>
>diff -Naru iptables-1.4.5/xtables.c iptables-1.4.5-new/xtables.c
>--- iptables-1.4.5/xtables.c	2010-01-12 02:47:16.293249537 +0530
>+++ iptables-1.4.5-new/xtables.c	2010-01-13 06:14:12.130185117 +0530
>@@ -455,8 +455,8 @@
> void xtables_parse_interface(const char *arg, char *vianame,
> 			     unsigned char *mask)
> {
>-	int vialen = strlen(arg);
> 	unsigned int i;
>+	static char kernel_name[IFNAMSIZ];
> 
> 	memset(mask, 0, IFNAMSIZ);
> 	memset(vianame, 0, IFNAMSIZ);
>@@ -466,7 +466,11 @@
> 			   "interface name `%s' must be shorter than IFNAMSIZ"
> 			   " (%i)", arg, IFNAMSIZ-1);
> 
>-	strcpy(vianame, arg);
>+	if (netdev_alias_to_kernel_name(arg, kernel_name) < 0)
>+		show_alias_name_usage();
>+	
>+	strcpy(vianame, kernel_name);
>+	int vialen = strlen(kernel_name);
> 	if ((vialen == 0) || (vialen == 1 && vianame[0] == '+'))
> 		memset(mask, 0, IFNAMSIZ);
> 	else if (vianame[vialen - 1] == '+') {

That code, even if snippet, needs more work.

(iptables is not too great on multithread safety, but do we have to
make it worse by adding static buffers? And unchecked strcpy, what
should BPF think of us?)

>where kernel_name is the ethN name that will be returned by a library
>like libnetdevname which will map the user supplied "Embedded_NIC_1"
>name to the corresponding ethN name, thus bringing in determinism while
>referring to the network interfaces.
>
>Netfilter-devel, would this be acceptable ?

I tried to look at libnetdevname. There is a gitweb, but no
git-clone. I think that they library should possibly use netlink
and libtool. And other remarks.
