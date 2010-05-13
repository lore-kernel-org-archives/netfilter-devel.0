From: Patrick McHardy <kaber@trash.net>
Subject: iptables-next/TEE extension
Date: Thu, 13 May 2010 15:50:50 +0200
Message-ID: <4BEC03BA.3090501@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55778 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab0EMNuz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 May 2010 09:50:55 -0400
Received: from [192.168.0.100] (unknown [78.42.107.241])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by stinky.trash.net (Postfix) with ESMTPSA id 86155B2C53
	for <netfilter-devel@vger.kernel.org>; Thu, 13 May 2010 15:50:54 +0200 (MEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I've created a new branch "iptables-next" in the iptables git
repository, containing support for new features in the net-next
tree.

Currently the only new feature requiring userspace support is
the "TEE" target.
