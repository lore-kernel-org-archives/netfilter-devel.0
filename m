From: Patrick McHardy <kaber@trash.net>
Subject: iptables -git automake warnings
Date: Mon, 12 Jan 2009 06:44:39 +0100
Message-ID: <496AD8C7.2020208@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56079 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZALFoz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2009 00:44:55 -0500
Received: from [192.168.0.100] (unknown [78.42.204.165])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by stinky.trash.net (Postfix) with ESMTPSA id 39E00948B9
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Jan 2009 06:44:54 +0100 (MET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I get this with the current iptables -git version:

Makefile.am:7: `:='-style assignments are not portable
Makefile.am:71: `:='-style assignments are not portable
Makefile.am:72: `:='-style assignments are not portable
Makefile.am:73: `:='-style assignments are not portable
Makefile.am:74: `:='-style assignments are not portable
Makefile.am:75: `:='-style assignments are not portable
Makefile.am:78: `:='-style assignments are not portable
Makefile.am:80: `:='-style assignments are not portable
Makefile.am:97: `%'-style pattern rules are a GNU make extension

