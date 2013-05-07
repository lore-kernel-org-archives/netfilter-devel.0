From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: nfacct version dependency
Date: Tue, 07 May 2013 15:15:52 +0200
Message-ID: <3347028.Gq033PXqRA@storm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:39323 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758336Ab3EGNgF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 May 2013 09:36:05 -0400
Received: from intranator.m.i2n (unknown [172.16.1.99])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by re04.intra2net.com (Postfix) with ESMTP id EECAF30128
	for <netfilter-devel@vger.kernel.org>; Tue,  7 May 2013 15:15:57 +0200 (CEST)
Received: from localhost (intranator.m.i2n [127.0.0.1])
	by localhost (Postfix) with ESMTP id 630372AC5A
	for <netfilter-devel@vger.kernel.org>; Tue,  7 May 2013 15:15:57 +0200 (CEST)
Received: from storm.localnet (storm.m.i2n [172.16.1.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by intranator.m.i2n (Postfix) with ESMTPS id 955052AC51
	for <netfilter-devel@vger.kernel.org>; Tue,  7 May 2013 15:15:53 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

nfacct currently requires "libnetfilter_acct >= 1.0.2"
which has not been released yet.

Any plans to release a new version of both tools?

We can fix nfacct's configure.ac though
both git trees contain nice bugfixes.

Cheers,
Thomas

