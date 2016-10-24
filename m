From: Ulrich Weber <uweber.linux@gmail.com>
Subject: Re: [PATCH] nf_conntrack_sip: check for trailing spaces
Date: Mon, 24 Oct 2016 18:05:04 +0200
Message-ID: <da198c8e-1728-1105-d0d2-74b453995d0e@gmail.com>
References: <20161019082402.GA4575@gir> <20161020181732.GA10930@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
        Marco Angaroni <marcoangaroni@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Ulrich Weber <ulrich.weber@riverbed.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34390 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933767AbcJXQFH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Oct 2016 12:05:07 -0400
Received: by mail-wm0-f66.google.com with SMTP id d199so10522673wmd.1
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Oct 2016 09:05:07 -0700 (PDT)
In-Reply-To: <20161020181732.GA10930@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

good point, will send a new version!

Thanks
 Ulrich

On 20.10.2016 20:17, Pablo Neira Ayuso wrote:
> Hi Ulrich,
> 
> Cc'ing Marco Angaroni.
> 
> On Wed, Oct 19, 2016 at 10:24:02AM +0200, Ulrich Weber wrote:
>> on SIP requests, so a fragmented TCP SIP packet starting with
>>  INVITE,NOTIFY,OPTIONS,REFER,REGISTER,UPDATE,SUBSCRIBE
>>  Content-Length: 0
>>
>> will not bet interpreted as an INVITE request.
>>
>> Confirm with RFC 3261
>>  Request-Line   =  Method SP Request-URI SP SIP-Version CRLF
> 
> Marco has missed your email, so I'm copying and pasting what he told
> me wrt. to your patch:
> 
> My understanding is that Ulrich is referring to something like an
> "Allow" header of a SIP message where the header name is part of a TCP
> segment and the header value is part of the following TCP segment:
> 
> Allow: INVITE,ACK,CANCEL,OPTIONS,BYE
> 
> So I think the fix (check for a space after the method name) is
> correct.
> However maybe the check could be made more robust, because if you have
> the fragmented "Allow" header containing the method names with a space
> before comma (it's permitted by SIP grammar) like you see below, you
> would again think that it's the first line of the SIP message:
> 
> Allow: INVITE , ACK , CANCEL , OPTIONS , BYE
> 
> Maybe it's worth checking two bytes after method name; the first byte
> must be a space and the second must a alphanumeric character: the URI
> following the method name has to start with "sip:" or "sips:" or some
> other scheme, which starts for sure with an ALPHA character.
> 
> Request-Line   =  Method SP Request-URI SP SIP-Version CRLF
> Request-URI    =  SIP-URI / SIPS-URI / absoluteURI
> absoluteURI = scheme ":" ( hier-part / opaque-part )
> scheme         =  ALPHA *( ALPHA / DIGIT / "+" / "-" / "." )
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

