From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [PATCH lnf-queue] examples: attaching a conntrack information
Date: Thu, 10 Sep 2015 07:22:50 +0900
Message-ID: <20150909222250.GA545@gmail.com>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <20150909095042.GA11843@gmail.com>
 <20150909095851.GD11843@gmail.com>
 <20150909202932.GC24810@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36319 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbbIIWW4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Sep 2015 18:22:56 -0400
Received: by padhk3 with SMTP id hk3so22190052pad.3
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Sep 2015 15:22:55 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150909202932.GC24810@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 09, 2015 at 10:29:32PM +0200, Florian Westphal wrote:
> Ken-ichirou MATSUZAWA <chamaken@gmail.com> wrote:
> > +	if (attr == NULL)
> > +		return MNL_CB_OK;
> > +	attr->nla_len = 12;
> 
> What this?

I just wanted to test const qualifier... sorry.
Would you mind deleting the line? or should I send it again?

Thakns,
