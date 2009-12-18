From: <Narendra_K@Dell.com>
Subject: RE: [PROPOSAL]: Alias names for network interfaces
Date: Fri, 18 Dec 2009 18:49:15 +0530
Message-ID: <EDA0A4495861324DA2618B4C45DCB3EE5898C7@blrx3m08.blr.amer.dell.com>
References: <EDA0A4495861324DA2618B4C45DCB3EE5898BB@blrx3m08.blr.amer.dell.com> <alpine.LSU.2.01.0912171506130.5925@obet.zrqbmnf.qr> <20091218020241.GA18168@lina.inka.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Cc: <net-tools@lina.inka.de>, <shemminger@osdl.org>,
	<netfilter-devel@vger.kernel.org>, <jgarzik@users.sourceforge.net>,
	<Matt_Domsch@Dell.com>, <Charles_Rose@Dell.com>,
	<Jordan_Hargrave@Dell.com>, <Sandeep_K_Shandilya@Dell.com>
To: <be-mail2009@lina.inka.de>, <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ausxippc101.us.dell.com ([143.166.85.207]:42467 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbZLRNTZ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2009 08:19:25 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20091218020241.GA18168@lina.inka.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> 
> On Thu, Dec 17, 2009 at 03:48:02PM +0100, Jan Engelhardt wrote:
> > The development of net-tools has long ceased (since 2001), except
> > that no one seems to notice and everybody still applies voltage to a
> > dead horse. It's only going to smell bad.
> 
> Anyway: I think it is good to give interfaces a stable name by the
> installer
> of the distribution. Isnt that what ifrename is used for?
> 
> I am not sure what the patch is supposed to do?
> 

The installer solution involved renaming the network interface names
from ethN to something else based on the naming convention that the user
specified. For example, if the user chose "smbios names" as the the
naming convention then all ethN would be renamed to Embedded_NIC_N.
ifconfig would show Embedded_NIC_N instead of ethN. 

I suppose the ifrename would rename network interfaces from ethN to ethN
and that would cause issues. The current proposal aims at providing non
ethN aliases like Embedded_NIC_N which would be mapped to an ethN name
by the proposed library (such as libnetdevname) which can then be used
for further operations. The SMBIOS tables provide these names and as the
BIOS would name the integrated port 1 of the system Embedded_NIC_1
always, irrespective of how the OS names it (i.e eth0 or eth1). This
brings in determinism into the way interfaces are referred to.

Current installer implementations do provide a way for persistency by
associating MAC addressees, but they do not have a way to assure
expected naming.

With regards,
Narendra K
