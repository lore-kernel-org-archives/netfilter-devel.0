From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: next iptables release
Date: Sat, 21 Mar 2009 15:46:47 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0903211542140.7844@ask.diku.dk>
References: <49C202EA.40006@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Jan Engelhardt <jengelh@medozas.de>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:39238 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbZCUOq5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Mar 2009 10:46:57 -0400
In-Reply-To: <49C202EA.40006@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 19 Mar 2009, Patrick McHardy wrote:

> I've planned to release the next iptables version sometime (late)
> this weekend. We've had quite a lot of changes since the last
> version, please test the latest version from git and report any
> issues.

I just realized a bug in libiptc.c in func TC_RENAME_CHAIN.
The rename should insert the new chain name sorted, as my binary 
search system / skip-list rely on it.

I don't have time to fix it until monday. Jan, feel free to fix it up 
before I do...

Cheers,
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------

commit 6b7e7cde912a6395cb2a1f5e4b2f50cad2592b17
Author: Jesper Dangaard Brouer <hawk@comx.dk>
Date:   Sat Mar 21 15:40:54 2009 +0100

     I just realized a bug in libiptc.c in func TC_RENAME_CHAIN.
     Due my bsearch/skip-list implementation.

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 544a5b2..3bcae9c 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -2404,6 +2404,8 @@ int TC_RENAME_CHAIN(const IPT_CHAINLABEL oldname,
  		return 0;
  	}

+	/* FIXME: Bug here due to the bsearch system, new chain name
+	   needs to be inserted sorted */
  	strncpy(c->name, newname, sizeof(IPT_CHAINLABEL));

  	set_changed(handle);
