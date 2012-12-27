From: Eric Leblond <eric@regit.org>
Subject: Re: [ULOGD PATCH 0/2] Add Graphite output module
Date: Thu, 27 Dec 2012 09:22:45 +0100
Message-ID: <1356596565.1102.3.camel@tiger2>
References: <1356175711-13254-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:45158 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab2L0IXV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Dec 2012 03:23:21 -0500
Received: from bayen.regit.org ([81.57.69.189] helo=[192.168.1.128])
	by ks28632.kimsufi.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <eric@regit.org>)
	id 1To8kK-00052C-9G
	for netfilter-devel@vger.kernel.org; Thu, 27 Dec 2012 09:23:20 +0100
In-Reply-To: <1356175711-13254-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Sat, 2012-12-22 at 12:28 +0100, Eric Leblond wrote:
> This patchset adds a new output module to ulogd2. This is a module
> which sends NFACCT accounting data to a graphite server.
> Graphite is a web application which provide real-time visualization
> and storage of numeric time-series data. The exchange format is
> really simple and does not rely on any depedencies.
> 
> For a example dashboard and some more explanations see:
> https://home.regit.org/2012/12/visualize-netfilter-accounting-in-graphite/

Patches have been applied.

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

