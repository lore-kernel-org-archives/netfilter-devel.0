From: Pierre Chifflier <chifflier@edenwall.com>
Subject: [ULOGD2] UNIXSOCK plugin (v6)
Date: Mon,  1 Mar 2010 23:16:30 +0100
Message-ID: <1267481792-22729-1-git-send-email-chifflier@edenwall.com>
References: <4B8C16A4.9010807@netfilter.org>
Cc: eleblond@edenwall.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:41974 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711Ab0CAWRK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Mar 2010 17:17:10 -0500
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id AFD3394011F
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Mar 2010 23:17:02 +0100 (CET)
Received: from fydelkass.edenwall.com (fydelkass.inl.fr [88.171.131.12])
	by smtp1-g21.free.fr (Postfix) with ESMTP id CC39194007C
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Mar 2010 23:16:59 +0100 (CET)
In-Reply-To: <4B8C16A4.9010807@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,

Here is the sixth version with (I think) every changed included.
* empty lines removed,
* enum added for future transition of xyz_ce macros,
* alignment changed and tested,
* socket no more automatically removed when starting,
* code more 80-chars compliant

BR,
Pierre
