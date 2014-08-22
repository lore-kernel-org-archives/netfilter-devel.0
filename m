From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Easy network (config) breakage with 3.17-rc1:
 NETFILTER_XT_TARGET_LOG
Date: Fri, 22 Aug 2014 20:01:12 +0200
Message-ID: <20140822180112.GB3402@salvia>
References: <CACna6rymZjgex0p1snf3e-GvK2xHrQST3roGiA3F__y3DvYhKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="CE+1k2dSO48ffgeK"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35203 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932410AbaHVSAa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Aug 2014 14:00:30 -0400
Content-Disposition: inline
In-Reply-To: <CACna6rymZjgex0p1snf3e-GvK2xHrQST3roGiA3F__y3DvYhKw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Aug 21, 2014 at 12:49:33PM +0200, Rafał Miłecki wrote:
> Few days ago I updated my 3.16 to 3.17-rc1 (both self compiled) and I
> was using it until I noticed my machine doesn't respond to pings. I
> rebooted to 3.16 and it was working again.
> 
> I bisected between 3.16 and 3.17-rc1 but it has failed. After all I
> got 3.16 not working anymore as well.
> 
> It took me few hours to find the one to blame:
> CONFIG_NETFILTER_XT_TARGET_LOG. After moving my config from 3.16 to
> 3.17-rc1 CONFIG_NETFILTER_XT_TARGET_LOG got disabled because of two
> new dependencies: NF_LOG_IPV4 && NF_LOG_IPV6.
> 
> It would be nice if you could try to use "select" instead of "depends
> on" in such cases in the future. I bet fix my problem would be trivial
> since the beginning, but end-users may spent hours or days tracking
> such things :(

Sorry for that Kconfig problem. Please, have a look at the attached
patch and confirm that it fixes the problem. At quick glance I think
it's safe to use select in this case.

> Please, treat it as an advise/request, not a blaming :)

It's good indeed that you have reported this, we're still in -rc1
which means that we can still fix things.

If you have any further problem, please let us know. Thanks.

--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=x

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 05eb177..44625d8 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -747,7 +747,8 @@ config NETFILTER_XT_TARGET_LED
 
 config NETFILTER_XT_TARGET_LOG
 	tristate "LOG target support"
-	depends on NF_LOG_IPV4 && NF_LOG_IPV6
+	select NF_LOG_IPV4
+	select NF_LOG_IPV6
 	default m if NETFILTER_ADVANCED=n
 	help
 	  This option adds a `LOG' target, which allows you to create rules in

--CE+1k2dSO48ffgeK--
