From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] parser_bison: Allow parens on RHS of relational_expr
Date: Tue, 29 Nov 2016 22:19:31 +0100
Message-ID: <20161129211931.GA6409@salvia>
References: <20161128175143.25201-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39550 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756717AbcK2VTn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2016 16:19:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 06BDE174D1F
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 22:19:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA4B5DA391
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 22:19:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6A36EDA391
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 22:19:32 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161128175143.25201-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 28, 2016 at 06:51:43PM +0100, Phil Sutter wrote:
> This is useful to allow a construct such as:
> 
> | tcp flags & (syn|fin) == (syn|fin)
> 
> Before, only the parentheses on the left side were allowed, but via a
> quite funny path through the parser:
> 
> * expr might be a concat_expr
> * concat_expr might be a basic_expr
> * basic_expr is an inclusive_or_expr
> * inclusive_or_expr might be an exclusive_or_expr
> * exclusive_or_expr might be an and_expr
> * and_expr might be 'and_expr AMPERSAND shift_expr'
>   -> here we eliminate 'flags &' in above statement
> * shift_expr might be a primary_expr
> * primary_expr might be '( basic_expr )'
> 
> Commit a3e60492a684b ("parser: restrict relational rhs expression
> recursion") introduced rhs_expr to disallow recursion on RHS, so just
> reverting that change for relational_expr is a no go. Allowing rhs_expr
> to be '( rhs_expr )' though seems way too intrusive to me since it's
> being used in all kinds of places, so this patch is the safest way to
> allow the above I could come up with.

Applied, thanks Phil!
