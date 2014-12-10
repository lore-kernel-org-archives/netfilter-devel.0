From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: conntrack-tools: cli test script broken
Date: Wed, 10 Dec 2014 17:35:26 +0100
Message-ID: <22514604.4VtIGkY3Iv@storm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: 'Netfilter Developer Mailing List'
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs04.intra2net.com ([85.214.66.2]:34426 "EHLO
	rs04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbaLJREE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:04:04 -0500
Received: from intranator.m.i2n (unknown [172.16.1.99])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by rs04.intra2net.com (Postfix) with ESMTP id A1BFD220128
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Dec 2014 17:35:28 +0100 (CET)
Received: from localhost (intranator.m.i2n [127.0.0.1])
	by localhost (Postfix) with ESMTP id 575C22AC55
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Dec 2014 17:35:28 +0100 (CET)
Received: from storm.localnet (storm.m.i2n [172.16.1.2])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by intranator.m.i2n (Postfix) with ESMTPS id 5FF412AC54
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Dec 2014 17:35:26 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

when I run the test script of conntrack-tools

    sh doc/cli/test.sh create-expect

the output is

conntrack v1.4.1 (conntrack-tools): You need to supply the `--reply-port-src' option for this command
Try `conntrack -h' or 'conntrack --help' for more information.


This used to work without the --reply-port-src stuff
using version 0.9.13 IIRC.

I didn't see any commits changing the cmdline parser
in git since v1.4.1, so I guess it's still broken.

Cheers,
Thomas

