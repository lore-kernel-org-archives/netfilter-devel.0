From: Abhijit Menon-Sen <ams@toroid.org>
Subject: using libnetfilter_queue
Date: Sat, 17 Nov 2007 02:32:50 +0530
Message-ID: <20071116210250.GA16546@toroid.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fugue.toroid.org ([85.10.196.113]:3696 "EHLO fugue.toroid.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757572AbXKPVgH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:36:07 -0500
Received: from penne (localhost [127.0.0.1])
	by fugue.toroid.org (Postfix) with ESMTP id C9E18109C8
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Nov 2007 22:02:51 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

(I posted to the lartc mailing list, and received no responses, so I'm
posting here too.)

Hi.

Has anyone written or used, or does anyone know of, applications that
use libnetfilter_queue to mangle packets in userspace before letting
them proceed on their way?

I'm wondering if it's possible to write a not-quite-transparent proxy
that way, and looking for documentation, examples, and inspiration.

Thanks.

-- ams
