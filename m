From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] src: rule: fix compat XML output
Date: Fri, 19 Apr 2013 01:29:38 +0200
Message-ID: <20130418232938.GA16842@localhost>
References: <20130408083502.9509.95918.stgit@nfdev.cica.es>
 <20130409194900.GB5544@localhost>
 <CAOkSjBiy4LGkUJ4dafW_UXfnw8sJOecVnv5OrgWz6D1=1ywuDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51068 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936608Ab3DRX3o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Apr 2013 19:29:44 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBiy4LGkUJ4dafW_UXfnw8sJOecVnv5OrgWz6D1=1ywuDA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 09, 2013 at 10:34:17PM +0200, Arturo Borrero Gonzalez wrote:
> 2013/4/9 Pablo Neira Ayuso <pablo@netfilter.org>:
> >
> > Does it clarify?
> 
> I agree with you.
> 
> If you choose to commit this, I will patch (out) all XML extra
> formatting (newlines, tabs...).

I have applied this, as you sent already a major follow-up to address
all formatting XML issues.
