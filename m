From: Eric Leblond <eric@regit.org>
Subject: [ULOGD PATCH 0/2] Add Graphite output module
Date: Sat, 22 Dec 2012 12:28:29 +0100
Message-ID: <1356175711-13254-1-git-send-email-eric@regit.org>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:54709 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2LVL3S (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Dec 2012 06:29:18 -0500
Received: from bayen.regit.org ([81.57.69.189] helo=localhost.localdomain)
	by ks28632.kimsufi.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <eric@regit.org>)
	id 1TmNGV-0001jD-SQ
	for netfilter-devel@vger.kernel.org; Sat, 22 Dec 2012 12:29:16 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This patchset adds a new output module to ulogd2. This is a module
which sends NFACCT accounting data to a graphite server.
Graphite is a web application which provide real-time visualization
and storage of numeric time-series data. The exchange format is
really simple and does not rely on any depedencies.

For a example dashboard and some more explanations see:
https://home.regit.org/2012/12/visualize-netfilter-accounting-in-graphite/

BR,
--
Eric Leblond <eric@regit.org>
