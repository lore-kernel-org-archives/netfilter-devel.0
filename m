From: Thomas Jacob <jacob@internet24.de>
Subject: hashlimit supports only up to 10.000 pps
Date: Mon, 06 Jul 2009 11:53:13 +0200
Message-ID: <1246873993.8053.9.camel@enterprise.ims-firmen.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout02.ims-firmen.de ([213.174.32.97]:52749 "EHLO
	mailout02.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968AbZGFJxM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2009 05:53:12 -0400
Received: from mailin03.ims-firmen.de ([192.168.1.112])
	by mailout02.ims-firmen.de with esmtp (Exim 4.69)
	(envelope-from <jacob@internet24.de>)
	id 1MNkss-00056I-Ji
	for netfilter-devel@vger.kernel.org; Mon, 06 Jul 2009 11:53:14 +0200
Received: from [213.174.32.254] (helo=[192.168.0.170])
	by mailin03.ims-firmen.de with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <jacob@internet24.de>)
	id 1MNkss-0003PY-HY
	for netfilter-devel@vger.kernel.org; Mon, 06 Jul 2009 11:53:14 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since hashlimit has come up on the list today:

Is there any technical reason why hashlimit has a built in maximum
limit of only 10k pps? If not, are there any plans of some of the core
developers to increase that limit in the near future? If not, I presume
that patches would be welcome?

10k pps isn't exactly a lot these days.

        Thomas

