From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [OOPS PATCH 0/1] netfilter/sip: fix OOPS in flush_expectations()
Date: Mon, 14 Oct 2013 15:46:38 +0200
Message-ID: <20131014134638.GL13405@imap.eitzenberger.org>
References: <20131011140204.916097373@eitzenberger.org>
 <20131011203749.GA20502@localhost>
 <20131012055807.GI13405@imap.eitzenberger.org>
 <20131012085215.GB28765@macbook.localnet>
 <20131012101121.GJ13405@imap.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:60978 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab3JNNql (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:46:41 -0400
Content-Disposition: inline
In-Reply-To: <20131012101121.GJ13405@imap.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

> > I've reviewed the code and all I could find wrt. missing locking is the
> > call to nf_ct_remove_expectations() in process_urq() (H.323). Is the
> > H.323 helper used on the machine where you're experiencing the crash?
> 
> I can check on Monday.

The helper is loaded on at least one of those two systems.

