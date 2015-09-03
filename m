From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] solve musl build problem
Date: Thu, 3 Sep 2015 18:54:02 +0200
Message-ID: <20150903165402.GA23890@salvia>
References: <1441298310-3951-1-git-send-email-brendanheading@gmail.com>
 <20150903164739.GA21105@salvia>
 <CA+BsyQ79wP-ut+kXxmWZvW3qnTs0MFxj7NdLs7yi-2nK_4iExw@mail.gmail.com>
 <CA+BsyQ7oC6Uyycp0VeyRxdckrwW+7vmtKpz=8LTFbNKb9VEztg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Brendan Heading <brendanheading@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42108 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbbICQra (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Sep 2015 12:47:30 -0400
Content-Disposition: inline
In-Reply-To: <CA+BsyQ7oC6Uyycp0VeyRxdckrwW+7vmtKpz=8LTFbNKb9VEztg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 03, 2015 at 05:43:40PM +0100, Brendan Heading wrote:
> On 3 September 2015 at 17:42, Brendan Heading <brendanheading@gmail.com> wrote:
> > Sorry Pablo - wrong mailing list! Please ignore.
> 
> Pablo - the patch is intended for ebtables.

.../ebtables$ ls
ChangeLog         ebtables-restore.c     getethertype.c
communication.c   ebtables-restore.o     getethertype.o
communication.o   ebtables-save          include
COPYING           ebtables.spec          INSTALL
ebtables          ebtables-standalone.c  libebtc.c
ebtables.8        ebtables-standalone.o  libebtc.o
ebtables.c        ebtables.sysv          libebtc.so
ebtables-config   ebtablesu.c            Makefile
ebtablesd.c       ethertypes             THANKS
ebtables.o        examples               useful_functions.c
ebtables-restore  extensions             useful_functions.o

../ebtables$ find . | grep src

Hm, I see no 'src' directory under ebtables.
