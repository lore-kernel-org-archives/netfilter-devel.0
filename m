From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv3] tests: py: Add test for ambiguity while setting the
 value
Date: Sun, 18 Jun 2017 11:31:37 +0200
Message-ID: <20170618093137.GA12806@salvia>
References: <1497641742-25272-1-git-send-email-mayhs11saini@gmail.com>
 <20170618092913.GA8026@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45356 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752722AbdFRJbq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Jun 2017 05:31:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3D57EE1238
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Jun 2017 11:31:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2638E100A6E
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Jun 2017 11:31:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 358CBFF2D5
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Jun 2017 11:31:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170618092913.GA8026@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jun 18, 2017 at 11:29:13AM +0200, Pablo Neira Ayuso wrote:
> On Sat, Jun 17, 2017 at 01:05:42AM +0530, Shyam Saini wrote:
> > This test checks bug identified and fixed in the commit mentioned below
> > In a statement if there are  multiple src data then it  would be
> > totally ambiguous to decide which value to set.
> > 
> > Before the commit was made it returned 134(BUG), but now it returns 1
> > i.e, an error message.
> 
> Applied, thanks.
> 
> One change though before applying, see below.
> 
> > Test: 986dea8 ("evaluate: avoid reference to multiple src data in
> > statements which set values")

BTW, please update .gitconfig in your home to add:

[core]
        abbrev = 12

So we get commit abbrev of 12 chars at least.

7 may lead to ambiguities in the future, as a hash with the same
prefix may show up later on.

Thanks!
