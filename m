From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PROPOSAL]: Alias names for network interfaces
Date: Fri, 18 Dec 2009 09:38:45 -0800
Message-ID: <20091218093845.00d7e918@nehalam>
References: <EDA0A4495861324DA2618B4C45DCB3EE5898BB@blrx3m08.blr.amer.dell.com>
	<alpine.LSU.2.01.0912171506130.5925@obet.zrqbmnf.qr>
	<20091218020241.GA18168@lina.inka.de>
	<EDA0A4495861324DA2618B4C45DCB3EE5898C7@blrx3m08.blr.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: <be-mail2009@lina.inka.de>, <jengelh@medozas.de>,
	<net-tools@lina.inka.de>, <netfilter-devel@vger.kernel.org>,
	<jgarzik@users.sourceforge.net>, <Matt_Domsch@Dell.com>,
	<Charles_Rose@Dell.com>, <Jordan_Hargrave@Dell.com>,
	<Sandeep_K_Shandilya@Dell.com>
To: <Narendra_K@Dell.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753635AbZLRRkP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:40:15 -0500
In-Reply-To: <EDA0A4495861324DA2618B4C45DCB3EE5898C7@blrx3m08.blr.amer.dell.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 18 Dec 2009 18:49:15 +0530
<Narendra_K@Dell.com> wrote:

> The installer solution involved renaming the network interface names
> from ethN to something else based on the naming convention that the user
> specified. For example, if the user chose "smbios names" as the the
> naming convention then all ethN would be renamed to Embedded_NIC_N.
> ifconfig would show Embedded_NIC_N instead of ethN.

Renaming away from ethN causes some applications like net-snmp to get confused,
and others have special sorting rules based on existing model (like quagga).

I would argue that the "ethN" convention is part of existing system
ABI and should not get changed in a visible way to applications.


-- 
