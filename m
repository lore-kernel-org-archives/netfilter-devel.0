From: Jan Engelhardt <jengelh@medozas.de>
Subject: RE: [PROPOSAL]: Alias names for network interfaces
Date: Fri, 18 Dec 2009 14:42:22 +0100 (CET)
Message-ID: <alpine.LSU.2.01.0912181433230.5810@obet.zrqbmnf.qr>
References: <EDA0A4495861324DA2618B4C45DCB3EE5898BB@blrx3m08.blr.amer.dell.com> <alpine.LSU.2.01.0912171506130.5925@obet.zrqbmnf.qr> <20091218020241.GA18168@lina.inka.de> <EDA0A4495861324DA2618B4C45DCB3EE5898C7@blrx3m08.blr.amer.dell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: be-mail2009@lina.inka.de, net-tools@lina.inka.de,
	shemminger@osdl.org, netfilter-devel@vger.kernel.org,
	jgarzik@users.sourceforge.net, Matt_Domsch@Dell.com,
	Charles_Rose@Dell.com, Jordan_Hargrave@Dell.com,
	Sandeep_K_Shandilya@Dell.com
To: Narendra_K@Dell.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54377 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbZLRNmX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2009 08:42:23 -0500
In-Reply-To: <EDA0A4495861324DA2618B4C45DCB3EE5898C7@blrx3m08.blr.amer.dell.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-12-18 14:19, Narendra_K@Dell.com wrote:
>>=20
>> Anyway: I think it is good to give interfaces a stable name by the
>> installer of the distribution. Isnt that what ifrename is used
>> for?
>>=20
>> I am not sure what the patch is supposed to do?
>
>The installer solution involved renaming the network interface names
>from ethN to something else based on the naming convention that the us=
er
>specified. For example, if the user chose "smbios names" as the the
>naming convention then all ethN would be renamed to Embedded_NIC_N.
>ifconfig would show Embedded_NIC_N instead of ethN.=20
>
>I suppose the ifrename would rename network interfaces from ethN to et=
hN
>and that would cause issues.

What issues?

>The current proposal aims at providing non
>ethN aliases like Embedded_NIC_N which would be mapped to an ethN name
>by the proposed library (such as libnetdevname) which can then be used
>for further operations.

What is wrong with just renaming the actual interface? In fact you
could use udev itself for just that. /lib/udev/write_net_rules,
and instead of continuing to use the name the kernel set aside,
let it call out to smbios and voil=C3=A0, your
/etc/udev/rules.d/70-persistent-net.rules would then show something
like:

SUBSYSTEM=3D=3D"net", DRIVERS=3D=3D"?*", ATTR{address}=3D=3D"00:20:18:8=
c:ce:70",
NAME=3D"PCI_NIC_0"

That is not hard, and has the nice side effect of propagating through
all possible programs, because it is the actual interface name rather
than some alias for which you would need a library first.
In short, I would see PCI_NIC_0 in iptraf. Today.

>The SMBIOS tables provide these names and as the
>BIOS would name the integrated port 1 of the system Embedded_NIC_1
>always, irrespective of how the OS names it (i.e eth0 or eth1). This
>brings in determinism into the way interfaces are referred to.
>Current installer implementations do provide a way for persistency by
>associating MAC addressees, but they do not have a way to assure
>expected naming.

Mapping MACs to interface names is a sort of determinism -- it
remains the same over time.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
