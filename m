From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nf_conntrack_sip: check for trailing spaces
Date: Thu, 20 Oct 2016 20:17:32 +0200
Message-ID: <20161020181732.GA10930@salvia>
References: <20161019082402.GA4575@gir>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
        Marco Angaroni <marcoangaroni@gmail.com>
To: Ulrich Weber <ulrich.weber@riverbed.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40012 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753366AbcJTSRo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Oct 2016 14:17:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1339A9D324
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 20:17:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F3E6DDA816
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 20:17:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C74F0DA847
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 20:17:37 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20161019082402.GA4575@gir>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Ulrich,

Cc'ing Marco Angaroni.

On Wed, Oct 19, 2016 at 10:24:02AM +0200, Ulrich Weber wrote:
> on SIP requests, so a fragmented TCP SIP packet starting with
>  INVITE,NOTIFY,OPTIONS,REFER,REGISTER,UPDATE,SUBSCRIBE
>  Content-Length: 0
> 
> will not bet interpreted as an INVITE request.
> 
> Confirm with RFC 3261
>  Request-Line   =  Method SP Request-URI SP SIP-Version CRLF

Marco has missed your email, so I'm copying and pasting what he told
me wrt. to your patch:

My understanding is that Ulrich is referring to something like an
"Allow" header of a SIP message where the header name is part of a TCP
segment and the header value is part of the following TCP segment:

Allow: INVITE,ACK,CANCEL,OPTIONS,BYE

So I think the fix (check for a space after the method name) is
correct.
However maybe the check could be made more robust, because if you have
the fragmented "Allow" header containing the method names with a space
before comma (it's permitted by SIP grammar) like you see below, you
would again think that it's the first line of the SIP message:

Allow: INVITE , ACK , CANCEL , OPTIONS , BYE

Maybe it's worth checking two bytes after method name; the first byte
must be a space and the second must a alphanumeric character: the URI
following the method name has to start with "sip:" or "sips:" or some
other scheme, which starts for sure with an ALPHA character.

Request-Line   =  Method SP Request-URI SP SIP-Version CRLF
Request-URI    =  SIP-URI / SIPS-URI / absoluteURI
absoluteURI = scheme ":" ( hier-part / opaque-part )
scheme         =  ALPHA *( ALPHA / DIGIT / "+" / "-" / "." )
