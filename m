From: =?iso-8859-15?Q?G=E9rald?= Colangelo <binarym@psycho-hazard.net>
Subject: libnetfilter_queue and pid of process owning packet.
Date: Fri, 17 Apr 2009 16:59:50 +0200
Message-ID: <20090417145949.GS3600@finnois.psycho-hazard.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from finnois.psycho-hazard.net ([91.121.135.173]:1928 "EHLO
	finnois.psycho-hazard.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbZDQPay (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:30:54 -0400
Received: from finnois.yanluo.net (dom0.local.psycho-hazard.net [10.0.0.1])
	by finnois.psycho-hazard.net (Postfix) with SMTP id 3E86F134075
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Apr 2009 16:59:50 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Is there a simple way to get the pid of the process owning the packet t=
hrought
libnetfilter_queue ?
I know that this parameters would only be revelant in case of OUPUTed p=
acket,
but i would be really useful for me ... :)
I have searched the web, browsed snort_inline, honeytrap and moblock so=
urce code,
but didn't find anything concerning my needs.

Regards,

--=20
G=E9rald Colangelo=20
binarym@psycho-hazard.net - http://www.yanluo.net

Being a sysadmin means hours of hard labor every day.
Being an abusive sysadmin means hours of fun.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
