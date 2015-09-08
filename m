From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v1 1/1] fix: resource leakage when loading library using
 dlopen
Date: Tue, 8 Sep 2015 12:38:41 +0200
Message-ID: <20150908103841.GA3605@salvia>
References: <1441622536-15123-1-git-send-email-imran.zaman@intel.com>
 <alpine.LSU.2.20.1509071238500.579@nerf40.vanv.qr>
 <0851720D2FAA48479DE89E28AEACE10E3B69D763@IRSMSX102.ger.corp.intel.com>
 <alpine.LSU.2.20.1509071506190.2437@nerf40.vanv.qr>
 <0851720D2FAA48479DE89E28AEACE10E3B69DAA6@IRSMSX102.ger.corp.intel.com>
 <alpine.LSU.2.20.1509081051090.24872@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Zaman, Imran" <imran.zaman@intel.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60145 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343AbbIHKcM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Sep 2015 06:32:12 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1509081051090.24872@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 08, 2015 at 10:55:30AM +0200, Jan Engelhardt wrote:
> On Tuesday 2015-09-08 09:02, Zaman, Imran wrote:
> 
> >Well! I tend to disagree here..
> >
> >Any resource should be freed immediately if it is not in use..
> 
> Yet they are in use until xtables-main.c:78 or so.

This lazy resource approach is sloppy. It's a good practise to release
things before leaving the program. By releasing things when we don't
need them anymore, we reduce the noise in valgrind and similar tools
so it becomes more easily to detect more significant problems in the
software.

Imran, please fix your patch to avoid the crash that was indicated in
first place and resubmit, thanks.
