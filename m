From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: correct allowed characters in Call-ID SIP
 header
Date: Wed, 7 Sep 2016 10:31:34 +0200
Message-ID: <20160907083134.GB2276@salvia>
References: <20160830164824._3CVoDOGb%marcoangaroni@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Marco Angaroni <marcoangaroni@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57062 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750938AbcIGIbo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Sep 2016 04:31:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 171D11022AD
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 10:31:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 053981150AF
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 10:31:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0654D1150AF
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 10:31:39 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160830164824._3CVoDOGb%marcoangaroni@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 30, 2016 at 06:48:24PM +0200, Marco Angaroni wrote:
> Current parsing methods for SIP header Call-ID do not check correctly all
> characters allowed by RFC 3261. In particular "," character is allowed 
> instead of "'" character. As a result Call-ID headers like the following
> are discarded by IPVS SIP persistence engine.
> 
> Call-ID: -.!%*_+`'~()<>:\"/[]?{}
> 
> Above example is composed using all non-alphanumeric characters listed
> in RFC 3261 for Call-ID header syntax.
> 
> Proposed fix is in nf_conntrack_sip module; function iswordc() checks this
> range: (c >= '(' && c <= '/') which includes these characters: ()*+,-./
> They are all allowed except ",". Instead "'" is not included in the list.
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

Also applied, thanks.
