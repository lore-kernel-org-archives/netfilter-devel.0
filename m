From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] erec: Make error messages in nft consistent
Date: Tue, 15 Nov 2016 20:50:10 +0100
Message-ID: <20161115195010.GA3948@salvia>
References: <20161115192237.GA29317@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37524 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752852AbcKOTuQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Nov 2016 14:50:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ABDC11C4389
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Nov 2016 20:50:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9C4F8DA7F6
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Nov 2016 20:50:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B50C3DA7F6
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Nov 2016 20:50:11 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161115192237.GA29317@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 15, 2016 at 05:22:38PM -0200, Elise Lennion wrote:
> Error messages in nft should start with "syntax error" to keep
> consistency. A new function add_syntax_error() was created to add this
> prefix when necessary.

Probably you can just add EREC_SYNTAX_ERROR to enum
error_record_types, then add:

#define syntax_error(loc, fmt, args...) \
       erec_create(EREC_SYNTA_ERROR, (loc), (fmt), ## args)

and use it from src/parser_bison.y

Thanks!
