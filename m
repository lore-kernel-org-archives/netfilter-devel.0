Return-Path: <SRS0=xcdV=XD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E45FC433EF
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 19:33:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F8D1216C8
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 19:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbfIHTdY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 8 Sep 2019 15:33:24 -0400
Received: from correo.us.es ([193.147.175.20]:55418 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727205AbfIHTdY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Sep 2019 15:33:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E9BD011EB86
        for <netfilter-devel@vger.kernel.org>; Sun,  8 Sep 2019 21:33:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0620A7E19
        for <netfilter-devel@vger.kernel.org>; Sun,  8 Sep 2019 21:33:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C5E9AA7E18; Sun,  8 Sep 2019 21:33:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B6DA4DA72F;
        Sun,  8 Sep 2019 21:33:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 08 Sep 2019 21:33:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 902B141E4801;
        Sun,  8 Sep 2019 21:33:18 +0200 (CEST)
Date:   Sun, 8 Sep 2019 21:33:20 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2] src: add synproxy stateful object support
Message-ID: <20190908193320.3dzkuwrjbuwhrclw@salvia>
References: <20190907183020.738-1-ffmancera@riseup.net>
 <20190907185532.odf3x26uuh5ctrza@salvia>
 <6c35d687-769c-a726-1bd5-9be4d8fe548d@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c35d687-769c-a726-1bd5-9be4d8fe548d@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Sep 08, 2019 at 08:37:38PM +0200, Fernando Fernandez Mancera wrote:
> Hi Pablo,
> 
> On 9/7/19 8:55 PM, Pablo Neira Ayuso wrote:
> > On Sat, Sep 07, 2019 at 08:30:22PM +0200, Fernando Fernandez Mancera wrote:
> >> Add support for "synproxy" stateful object. For example (for TCP port 80 and
> >> using maps with saddr):
> >>
> >> table ip foo {
> >> 	synproxy https-synproxy {
> >> 		synproxy mss 1460 wscale 7 timestamp sack-perm
> >> 	}
> > 
> > Please, update syntax, so this looks like:
> > 
> >  	synproxy https-synproxy {
> >  		mss 1460
> >                 wscale 7
> >                 timestamp sack-perm
> >  	}
> > 
> > One option per line.
> > 
> > Thanks!
> > 
> 
> I have updated the syntax.
> 
>     table ip foo {
>             synproxy https-synproxy {
>                     mss 1460
>                     wscale 7
>                     timestamp sack-perm
>             }
> 
>             synproxy other-synproxy {
>                     mss 1460
>                     wscale 5
>             }
> 
>             chain bar {
>                     tcp dport 80 synproxy name "https-synproxy"
>                     synproxy name ip saddr map { 192.168.1.0/24 :
> "https-synproxy", 192.168.2.0/24 : "other-synproxy" }
>             }
>     }
> 
> But then I am getting errors when using "nft -f". Then how it is
> possible to allow that on the parser?
> 
> mark:3:11-11: Error: syntax error, unexpected newline, expecting wscale
> 		mss 1460
> 		        ^
> mark:4:3-8: Error: syntax error, unexpected wscale
> 		wscale 7
> 		^^^^^^
> mark:5:3-11: Error: syntax error, unexpected timestamp
> 		timestamp sack-perm
> 		^^^^^^^^^
> mark:9:11-11: Error: syntax error, unexpected newline, expecting wscale
> 		mss 1460
> 		        ^
> mark:10:3-8: Error: syntax error, unexpected wscale
> 		wscale 5
> 		^^^^^^

Update the parser, have a look at ct helper, for instance.
