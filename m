From: Nicole <nicole@cats-muvva.net>
Subject: Allocating and destroying connection-related data
Date: Mon, 17 Sep 2012 12:41:05 +0100
Message-ID: <50570C51.2080104@cats-muvva.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.cats-muvva.net ([195.69.92.234]:51347 "EHLO
	hosting.cats-muvva.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756049Ab2IQLt7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Sep 2012 07:49:59 -0400
Received: from [192.168.9.2] (workbench.cats-muvva.net [192.168.9.2])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "CAcert WoT User", Issuer "CA Cert Signing Authority" (not verified))
	by hosting.cats-muvva.net (Postfix) with ESMTPS id A5F5A46EED
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Sep 2012 12:41:07 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear All,

Do you have a tutorial (or example) for how to write a module that
allocates and destroys its own small amount of data that can be
associated with any connection, including those for which a connection
tracker is already used?

Many thanks

Nicole
