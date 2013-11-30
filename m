From: Phil Oester <kernel@linuxace.com>
Subject: [RFC][PATCH] nftables: add slash to chain syntax
Date: Sat, 30 Nov 2013 15:20:23 -0800
Message-ID: <20131130232022.GA23206@home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:53937 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3K3XUX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Nov 2013 18:20:23 -0500
Received: by mail-pd0-f180.google.com with SMTP id q10so15659584pdj.39
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Nov 2013 15:20:23 -0800 (PST)
Received: from home (cpe-98-154-84-14.socal.res.rr.com. [98.154.84.14])
        by mx.google.com with ESMTPSA id tu6sm111604259pbc.41.2013.11.30.15.20.21
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 30 Nov 2013 15:20:22 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The current syntax when handling chains seems counterintuitive to me.  I would
expect that "add chain" would have the name of the chain directly after the
keyword "chain".  But instead, the name of the table is there, with the chain
after.  I think a better syntax might be this:

        add chain <table>/<chain>

which seems clearer to me.  And it has the added benefit of following the
"everything is a file" paradigm.  Who knows - maybe someday we can add a sysfs
interface for nftables, and this will fit nicely within a tree:

        nftables
          tables
            chains
              rules

Thoughts?  Attached patch is a general proof of concept.

Phil

