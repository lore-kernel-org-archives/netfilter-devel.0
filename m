Return-Path: <SRS0=xcdV=XD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7CC1C4360D
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 18:37:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8849B214DB
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 18:37:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="mWGb8K0s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729973AbfIHShi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 8 Sep 2019 14:37:38 -0400
Received: from mx1.riseup.net ([198.252.153.129]:52744 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729590AbfIHShi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Sep 2019 14:37:38 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 95B3F1A1611;
        Sun,  8 Sep 2019 11:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1567967857; bh=VdUawIgjHJnMd/23fvri0oGB2wGycfpOBd7mFSlL6L4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=mWGb8K0svT7diTKbKjhYCKtTo1yh26Cr8oBHmhu0QQj1ZFYaHkCVcvegAQ6h8o8ie
         um/j4uZ+5bDOUvIjm7XqHDFc+1RXc42EUl+5yJe432V5nrm+KPDC3HHmATXHAQH0C2
         Wk50ug5oEGXW22UYULX3pJgm4IFoDgw+cYfJPXVg=
X-Riseup-User-ID: 0BA98BE706B551396661F4BDEBD1D67D6C58FA77203C00093D8A1ED71CF3A01E
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 3F8AA22054E;
        Sun,  8 Sep 2019 11:37:32 -0700 (PDT)
Subject: Re: [PATCH nft v2] src: add synproxy stateful object support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20190907183020.738-1-ffmancera@riseup.net>
 <20190907185532.odf3x26uuh5ctrza@salvia>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Message-ID: <6c35d687-769c-a726-1bd5-9be4d8fe548d@riseup.net>
Date:   Sun, 8 Sep 2019 20:37:38 +0200
MIME-Version: 1.0
In-Reply-To: <20190907185532.odf3x26uuh5ctrza@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On 9/7/19 8:55 PM, Pablo Neira Ayuso wrote:
> On Sat, Sep 07, 2019 at 08:30:22PM +0200, Fernando Fernandez Mancera wrote:
>> Add support for "synproxy" stateful object. For example (for TCP port 80 and
>> using maps with saddr):
>>
>> table ip foo {
>> 	synproxy https-synproxy {
>> 		synproxy mss 1460 wscale 7 timestamp sack-perm
>> 	}
> 
> Please, update syntax, so this looks like:
> 
>  	synproxy https-synproxy {
>  		mss 1460
>                 wscale 7
>                 timestamp sack-perm
>  	}
> 
> One option per line.
> 
> Thanks!
> 

I have updated the syntax.

    table ip foo {
            synproxy https-synproxy {
                    mss 1460
                    wscale 7
                    timestamp sack-perm
            }

            synproxy other-synproxy {
                    mss 1460
                    wscale 5
            }

            chain bar {
                    tcp dport 80 synproxy name "https-synproxy"
                    synproxy name ip saddr map { 192.168.1.0/24 :
"https-synproxy", 192.168.2.0/24 : "other-synproxy" }
            }
    }

But then I am getting errors when using "nft -f". Then how it is
possible to allow that on the parser?

mark:3:11-11: Error: syntax error, unexpected newline, expecting wscale
		mss 1460
		        ^
mark:4:3-8: Error: syntax error, unexpected wscale
		wscale 7
		^^^^^^
mark:5:3-11: Error: syntax error, unexpected timestamp
		timestamp sack-perm
		^^^^^^^^^
mark:9:11-11: Error: syntax error, unexpected newline, expecting wscale
		mss 1460
		        ^
mark:10:3-8: Error: syntax error, unexpected wscale
		wscale 5
		^^^^^^

Thanks! :-)
