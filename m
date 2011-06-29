From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [Ebtables configuration] CONFIG_BRIDGE_NETFILTER ebtables dependency
Date: Wed, 29 Jun 2011 23:04:34 +0200
Message-ID: <4E0B9362.4070808@pandora.be>
References: <BANLkTik-boon=ACm9yEPaCV17jHQPLA01g@mail.gmail.com> <BANLkTinFeeEKrtUhMWXiKvCJ1UhR7Mf+1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090604030408050406000204"
Cc: netfilter-devel@vger.kernel.org
To: =?ISO-8859-1?Q?S=E9bastien_LAVEZE?= <slaveze@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:56008 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab1F2VEh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Jun 2011 17:04:37 -0400
In-Reply-To: <BANLkTinFeeEKrtUhMWXiKvCJ1UhR7Mf+1A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090604030408050406000204
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

This is indeed not the original intention. A fix to solve a build 
problem slipped in that actually changed the dependency from the 
original NETFILTER to BRIDGE_NETFILTER.
The attached patch reverts this change.

cheers,
Bart

Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>


On 29-06-11 10:25, Sébastien LAVEZE wrote:
> Hi all,
> Since a while I noticed that ebtables configuration is dependent upon
> CONFIG_BRIDGE_NETFILTER.
> Is there any specific reason for this ? There was not this dependency
> in the past and on top of it the description of bridge-netfilter in
> net/KConfig says the opposite:
>
> " Enabling this option will let arptables resp. iptables see bridged
>        ARP resp. IP traffic. If you want a bridging firewall, you probably
>        want this option enabled.
>        Enabling or disabling this option doesn't enable or disable
>        ebtables.
>
>        If unsure, say N."
>
>
> Thanks,
> Sebastien
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Bart De Schuymer
www.artinalgorithms.be


--------------090604030408050406000204
Content-Type: text/x-patch;
 name="Kconfig.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Kconfig.diff"

--- linux/net/bridge/netfilter/Kconfig.ori	2011-06-29 22:32:38.702734999 +0200
+++ linux/net/bridge/netfilter/Kconfig	2011-06-29 22:33:33.702734999 +0200
@@ -4,7 +4,7 @@
 
 menuconfig BRIDGE_NF_EBTABLES
 	tristate "Ethernet Bridge tables (ebtables) support"
-	depends on BRIDGE && BRIDGE_NETFILTER
+	depends on BRIDGE && NETFILTER
 	select NETFILTER_XTABLES
 	help
 	  ebtables is a general, extensible frame/packet identification

--------------090604030408050406000204--
