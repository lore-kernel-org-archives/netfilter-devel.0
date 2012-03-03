From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/7] [RFC] new cttimeout infrastructure
Date: Sat, 3 Mar 2012 14:40:24 +0100
Message-ID: <20120303134024.GB18857@1984>
References: <1330483172-19159-1-git-send-email-pablo@netfilter.org>
 <CABa6K_GKpkAiC7ae+-OwGG_b1iXyYD9+_xzF095XGTJ+e1aBWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58776 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab2CCNk1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Mar 2012 08:40:27 -0500
Content-Disposition: inline
In-Reply-To: <CABa6K_GKpkAiC7ae+-OwGG_b1iXyYD9+_xzF095XGTJ+e1aBWw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 01, 2012 at 08:51:56PM +0800, Changli Gao wrote:
> On Wed, Feb 29, 2012 at 10:39 AM,  <pablo@netfilter.org> wrote:
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> >
> > You can find the user-space library:
> >
> > http://git.netfilter.org/cgi-bin/gitweb.cgi?p=libnetfilter_cttimeout.git;a=summary
> >
> 
> IMHO we have too many such libraries. Why not combine all the library
> into one named after libnf or libnetfilter?

We discussed this before. We can release independent libraries in case
of bugs.
