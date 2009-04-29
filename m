From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables
Date: Wed, 29 Apr 2009 22:32:24 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904292232050.9772@fbirervta.pbzchgretzou.qr>
References: <49F56742.7080309@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Manu <manuprivat@gmx.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44260 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbZD2Uc1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Apr 2009 16:32:27 -0400
In-Reply-To: <49F56742.7080309@gmx.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-04-27 10:05, Manu wrote:
> #iptables -nvL -t mangle
>
> Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
> pkts bytes target     prot opt in     out     source               destination
> insmod: ip_tables.ko: no module by that name found
> modprobe: failed to load module ip_tables
> insmod: ip_tables.ko: no module by that name found
> modprobe: failed to load module ip_tables
> insmod: ip_tables.ko: no module by that name found
> modprobe: failed to load module ip_tables
> insmod: ip_tables.ko: no module by that name found
> modprobe: failed to load module ip_tables
>   0     0 MARK       all  --  *      *       10.0.20.2            0.0.0.0/0
> MARK set 0x14
>
>
> My kernel is built with every point of iptables stuff included, not as module.

I cannot reproduce this :/
