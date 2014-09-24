From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/3]: parser cleanups
Date: Wed, 24 Sep 2014 14:20:29 +0200
Message-ID: <1411561232-20204-1-git-send-email-kaber@trash.net>
Cc: eric@regit.org, arturo.borrero.glez@gmail.com,
	netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56690 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaIXMUg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:20:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As preparation for my parser rearrangement, I've cleaned up the grammar
a bit. The first two patches changes the queue statement to take an
expression for the queue numbers, the second one cleans up the export
format rules.

