From: Joerg Schumacher <schuma@gaertner.de>
Subject: [feature request] IPv6 match the second and further fragments
Date: Thu, 28 Jun 2012 15:16:56 +0200
Message-ID: <4FEC5948.2020807@gaertner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kenny.gaertner.de ([217.13.66.99]:37703 "EHLO kenny.gaertner.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab2F1N3x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jun 2012 09:29:53 -0400
Received: from [217.13.66.99] (kenny.gaertner.de [217.13.66.99])
	(authenticated bits=0)
	by kenny.gaertner.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id q5SDGuhM000676
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jun 2012 15:16:56 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'd like to match only the second and further fragments of
fragmented ipv6 packets.  The frag extension currently doesn't
facilitate this.  Could you please add this feature as perhaps

	! -- fragfirst

?

Thanks in advance,
Joerg
