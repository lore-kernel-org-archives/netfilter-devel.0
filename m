From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nft: Add support for inverted bitwise value list
Date: Wed, 22 Jun 2016 20:20:38 +0200
Message-ID: <20160622182038.GA14851@salvia>
References: <20160622154945.GA12610@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48886 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbcFVSUo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 14:20:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BFF94E8E90
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 20:20:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AA075FAB52
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 20:20:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 93CB1EBADB
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 20:20:39 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160622154945.GA12610@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 22, 2016 at 05:49:48PM +0200, Laura Garcia Liebana wrote:
> Add support for inverted state and status bitwise value list required in the
> ct match.
> 
> Before this patch, nft didn't support the rule:
> 
> $ nft add rule ip filter INPUT ct state != new,related counter accept
> <cmdline>:1:41-41: Error: syntax error, unexpected comma, expecting end of file or newline or semicolon
> add rule ip filter INPUT ct state != new,related counter accept
>                                         ^
> 
> This patch includes in the parser the ability to understand a list of
> bitwise values.
> 
> nft --debug=netlink add rule ip filter INPUT ct state != new,related,established,untracked counter accept
> ip filter INPUT
>   [ ct load state => reg 1 ]
>   [ cmp neq reg 1 0x0000004e ]
>   [ counter pkts 0 bytes 0 ]
>   [ immediate reg 0 accept ]

This bytecode looks incorrect.

nft --debug=netlink add rule ip filter INPUT ct state new,related,established,untracked
ip filter INPUT 
  [ ct load state => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x0000004e ) ^ 0x00000000 ]
  [ cmp neq reg 1 0x00000000 ]

so I think the right bytecode should look like:

nft --debug=netlink add rule ip filter INPUT ct state new,related,established,untracked
ip filter INPUT 
  [ ct load state => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x0000004e ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x00000000 ] 

I guess something is missing from the expr_evaluate_relational(), I
can see:

        if (rel->op == OP_IMPLICIT) {
                switch (right->ops->type) {
                ...
                case EXPR_LIST:
                        rel->op = OP_FLAGCMP;

I guess rel->op is OP_NEQ for your case above, that's why it is
generating the wrong code.

Note that from netlink_linearize.c, it is netlink_gen_flagcmp() that
generates the bitwise + cmp when we see OP_FLAGCMP.

Instead of this, I would kill the OP_FLAGCMP and transform the left
hand side of the tree to get a bitwise from evaluate.c, so this looks
like:

        relational (OP_NEQ)
                / \
               /   \
              /     \
         bitwise   value
            /  \
           /    \
     ct state   mask

Then, we can kill netlink_gen_flagcmp() too since the
netlink_linearize.c will generate the right bytecode for us based on
that tree.
