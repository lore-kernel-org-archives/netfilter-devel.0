From: Lutfi ODUNCUOGLU <lutfio@metu.edu.tr>
Subject: Ipset Problem
Date: Thu, 13 Sep 2012 17:19:27 +0300
Message-ID: <5051EB6F.2050406@metu.edu.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from frigya.general.services.metu.edu.tr ([144.122.145.140]:36483
	"EHLO frigya.general.services.metu.edu.tr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755508Ab2IMO00 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Sep 2012 10:26:26 -0400
Received: from [144.122.3.229] (sandal.cc.metu.edu.tr [144.122.3.229])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by frigya.general.services.metu.edu.tr (Postfix) with ESMTPSA id 6053A629A2
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Sep 2012 17:19:28 +0300 (EEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have two iptables configuration, for inet4 and inet6. In order to stop 
the iptables;

ipset flush
ipset destroy


and for ip6tables

ipset flush
ipset destroy


Can we make them just to flush and destroy inet6 or inet4? Is there any 
way? If not can you add this to request list?


Thanks in advance.

Lutfi
