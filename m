From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [PATCH RFC 0/3] Rework nfnetlink_queue conntrack support
Date: Fri, 11 Sep 2015 12:05:30 +0900
Message-ID: <20150911030530.GA7380@gmail.com>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <20150909095042.GA11843@gmail.com>
 <20150910000615.GB5734@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35607 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbbIKDFg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Sep 2015 23:05:36 -0400
Received: by pacfv12 with SMTP id fv12so62176244pac.2
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2015 20:05:35 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150910000615.GB5734@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 10, 2015 at 02:06:15AM +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 09, 2015 at 06:50:42PM +0900, Ken-ichirou MATSUZAWA wrote:
> > * We do not add another Kconfig for nflog attaching ct info?
> 
> I think you can add it too, yes.
> 
> So will you send a follow up patchset on top of those three to add
> what you need?

Would you see the following patch set?
I don't understand Kconfig part above well,
would you give me some advice?

Thanks,
