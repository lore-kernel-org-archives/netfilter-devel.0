From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH nft V4] src: Add import command for json
Date: Thu, 21 Sep 2017 13:08:26 +0200
Message-ID: <20170921110826.GB4504@salvia>
References: <1505902479-24405-1-git-send-email-mayhs11saini@gmail.com>
 <CAOkSjBj0SZ18kUPrp4r-4P18ZOwmC+6hS16ZSyOU=JOYK6UZTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shyam Saini <mayhs11saini@gmail.com>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:37141 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbdIULIa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Sep 2017 07:08:30 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBj0SZ18kUPrp4r-4P18ZOwmC+6hS16ZSyOU=JOYK6UZTw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 21, 2017 at 08:52:56AM +0200, Arturo Borrero Gonzalez wrote:
> On 20 September 2017 at 12:14, Shyam Saini <mayhs11saini@gmail.com> wrote:
> > This new operation allows to import ruleset in json to make
> > incremental changes using the parse functions of libnftnl.
> >
> > A basic way to test this new functionality is:
> >
> >  % cat file.json | nft import json
> >
> > where the file.json is a ruleset exported in json format.
> >
> > Highly based on work from  Alvaro Neira <alvaroneay@gmail.com>
> > and Arturo Borrero <arturo@netfilter.org>
> >
> > Acked-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
> > Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
> > ---
> > V4:
> >   Fix coding style issues
> >   Avoid nested function calls (As Suggested by Arturo )
> 
> LGTM
> 
> Thanks Shyam!
> 
> Just tested this patch, along with the one adding the testcase.
> All seems fine.
> 
> @Pablo, please, review and apply.

My only concern with this is that we'll end up having a json
representation in high-level format.

So I wonder if it would be good to make a distinction between the
low-level VM (Virtual-Machine) json representation and the high-level
one.

What I'm proposing is that we just add a command like this:

nft add export vm json

So the vm keyword specifies that we want a VM representation. So we
leave room for Eric Leblond's high level json representation.

I would turn 'nft export json' into no-op now, and we document this
change in the 0.8 release, since we aren't yet on 1.0, we still have a
bit of room to make these changes...

Fine with this?
