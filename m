From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libmnl PATCH] debug: don't colorize output on non tty
Date: Wed, 2 Oct 2013 17:25:12 +0200
Message-ID: <20131002152512.GA22293@localhost>
References: <1380577106-13006-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41895 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab3JBPZS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:25:18 -0400
Content-Disposition: inline
In-Reply-To: <1380577106-13006-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

On Mon, Sep 30, 2013 at 11:38:26PM +0200, Eric Leblond wrote:
> When output is not a tty (pipe or redirect to a file), the color
> display is causing the output to be unreadable:
>   02 00 00 00  |        |  extra header  |
>  |ESC[1;31m00008ESC[0m|ESC[1;32m--ESC[0m|ESC[1;34m00001ESC[0m|   |len |flags| type|
> This patch tests if the output is a terminal and only add color in
> this case. It also displays space instead of char 0 if a letter is
> not existing.

In both cases, you can use less -r to interpret the colors, is that
enough to address what you're noticing?

The chunk to replace char 0 by 32 looks fine to me.

Let me know.
