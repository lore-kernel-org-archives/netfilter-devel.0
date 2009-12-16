From: Tino Keitel <tkeitel@innominate.com>
Subject: conntrack -B undocumented
Date: Wed, 16 Dec 2009 18:42:05 +0100
Message-ID: <20091216174205.GA30937@tkeitel002.bln.innominate.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.innominate.com ([77.245.32.75]:52557 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbZLPRls (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:41:48 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by home.innominate.com (Postfix) with ESMTP id 8605F231BC
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Dec 2009 18:41:47 +0100 (CET)
Received: from home.innominate.com ([127.0.0.1])
	by localhost (localhost.localdomain [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G6vgqBFZ1Eev for <netfilter-devel@vger.kernel.org>;
	Wed, 16 Dec 2009 18:41:47 +0100 (CET)
Received: from tkeitel002.bln.innominate.local (tkeitel002.bln.innominate.local [10.1.0.104])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by home.innominate.com (Postfix) with ESMTPS id 6818C2304B
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Dec 2009 18:41:47 +0100 (CET)
Received: from tkeitel by tkeitel002.bln.innominate.local with local (Exim 4.69)
	(envelope-from <tkeitel@innominate.com>)
	id 1NKxsz-00083B-UK
	for netfilter-devel@vger.kernel.org; Wed, 16 Dec 2009 18:42:05 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

the example scripts for conntrackd (like primary-backup.sh) use a -B
option, which seems to be undocumented in the manual page and in the
command help.  What exactly is it intended for?

Regards,
Tino
