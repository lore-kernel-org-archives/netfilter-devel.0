From: Thomas Woerner <twoerner@redhat.com>
Subject: libnfnetlink license
Date: Wed, 07 Aug 2013 17:36:42 +0200
Message-ID: <5202698A.6070109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756804Ab3HGPgn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Aug 2013 11:36:43 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r77FaheC021905
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Wed, 7 Aug 2013 11:36:43 -0400
Received: from brasilia.fritz.box (brasilia.str.redhat.com [10.33.200.35])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r77FafQr002798
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Wed, 7 Aug 2013 11:36:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

according to the libnfnetlink README the license is GPLv2+, but the 
information in src/iftable.c and src/rtnl.c is "GNU GPLv2" without the 
"+". Is this intentional?

src/iftable.c: * This software is Free Software and licensed under GNU 
GPLv2.
src/rtnl.c: * This software is free software and licensed under GNU GPLv2.
README:This library is released under GPLv2+.


Regards,
Thomas
