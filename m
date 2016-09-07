From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: correct parsing of continuation lines in
 SIP headers
Date: Wed, 7 Sep 2016 10:31:16 +0200
Message-ID: <20160907083116.GA2276@salvia>
References: <20160830164819.A6zYgiNs5%marcoangaroni@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Marco Angaroni <marcoangaroni@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56770 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750957AbcIGIb1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Sep 2016 04:31:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F1756FF143
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 10:31:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E19B9100A5F
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 10:31:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B05FF115101
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 10:31:21 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160830164819.A6zYgiNs5%marcoangaroni@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 30, 2016 at 06:48:19PM +0200, Marco Angaroni wrote:
> Current parsing methods for SIP headers do not properly manage
> continuation lines: in case of Call-ID header the first character of
> Call-ID header value is truncated. As a result IPVS SIP persistence
> engine hashes over a call-id that is not exactly the one present in
> the originale message.
> 
> Example: "Call-ID: \r\n abcdeABCDE1234"
> results in extracted call-id equal to "bcdeABCDE1234".
> 
> In above example Call-ID is represented as a string in C language.
> Obviously in real message the first bytes after colon (":") are
> "20 0d 0a 20".
> 
> Proposed fix is in nf_conntrack_sip module.
> Since sip_follow_continuation() function walks past the leading
> spaces or tabs of the continuation line, sip_skip_whitespace()
> should simply return the ouput of sip_follow_continuation().
> Otherwise another iteration of the for loop is done and dptr
> is incremented by one pointing to the second character of the
> first word in the header.
> 
> Below is an extract of relevant SIP ABNF syntax.
> 
> Call-ID  =  ( "Call-ID" / "i" ) HCOLON callid
> callid   =  word [ "@" word ]
> 
> HCOLON  =  *( SP / HTAB ) ":" SWS
> SWS     =  [LWS] ; sep whitespace
> LWS     =  [*WSP CRLF] 1*WSP ; linear whitespace
> WSP     =  SP / HTAB
> word    =  1*(alphanum / "-" / "." / "!" / "%" / "*" /
>            "_" / "+" / "`" / "'" / "~" /
>            "(" / ")" / "<" / ">" /
>            ":" / "\" / DQUOTE /
>            "/" / "[" / "]" / "?" /
>            "{" / "}" )

Applied the mangled version, using break; instead.

Thanks!
