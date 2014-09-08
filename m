From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [PATCH 5/5] ipset: data callback does not need to be part of
 cb_ctl[]
Date: Mon, 8 Sep 2014 17:26:48 +0200
Message-ID: <20140908152648.GC16567@imap.eitzenberger.org>
References: <20140908142604.16930.94892.stgit@jonathan.eitzenberger.org>
 <20140908143053.16930.68662.stgit@jonathan.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:63779 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaIHP0v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:26:51 -0400
Content-Disposition: inline
In-Reply-To: <20140908143053.16930.68662.stgit@jonathan.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

> Because the data callback is passed explicitely to mnl_cb_run2()
> there is no need to add it to cb_ctl[].  For nlmsg_types
> >= NLMSG_MIN_TYPE the data callback is used explicitely.

Just noticed that there is a side effect to this one.  So please
just ignore this patch for now.
