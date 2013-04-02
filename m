From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables] git repository
Date: Tue, 2 Apr 2013 17:23:14 +0200
Message-ID: <20130402152314.GA13463@localhost>
References: <CAOkSjBi3siwiMn_TaBAty+VtZXuQs6VQwtGK5oyC0aMimrYkLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36237 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760543Ab3DBPXT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:23:19 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBi3siwiMn_TaBAty+VtZXuQs6VQwtGK5oyC0aMimrYkLA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 02, 2013 at 04:26:39PM +0200, Arturo Borrero Gonzalez wrote:
> Hi there!
> 
> I see that libnftables' git repository are in both 1984.lsi.us.es and
> git.netfilter.org.
> 
> But last patches only appear in git.netfilter.org.
> 
> As I've been using the 1984.lsi.us.es git remote, should I change to
> git.netfilter.org?

Yes.

You can change to the new location without a full clone easily by
editing the `url' parameter of your libnftables/.git/config file to
point to git://git.netfilter.org/libnftables.

You already had patches upon your local tree, you can use git pull --rebase.
If you're using stgit, IIRC you will have to pop all your patches,
pull from master, and the push your patches again.

Regards.
