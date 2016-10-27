From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] nf_conntrack_sip: extend request line validation
Date: Thu, 27 Oct 2016 18:29:36 +0200
Message-ID: <20161027162936.GA7955@salvia>
References: <20161024160723.GA30272@gir>
 <CANHHuCU6VoZFbP3TmKa1ajrJyFLydaSeqrwcSgycAB6chJmTHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ulrich Weber <ulrich.weber@riverbed.com>,
        netfilter-devel@vger.kernel.org, kaber@trash.net
To: Marco Angaroni <marcoangaroni@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36222 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933709AbcJ0Q3r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2016 12:29:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4A40D9B802
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 18:29:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 37BD4DA819
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 18:29:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0A091DA84D
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 18:29:37 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CANHHuCU6VoZFbP3TmKa1ajrJyFLydaSeqrwcSgycAB6chJmTHw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 25, 2016 at 09:07:23AM +0200, Marco Angaroni wrote:
> Hello,
> 
> 2016-10-24 18:07 GMT+02:00 Ulrich Weber <ulrich.weber@riverbed.com>:
> > on SIP requests, so a fragmented TCP SIP packet from an allow header starting with
> >  INVITE,NOTIFY,OPTIONS,REFER,REGISTER,UPDATE,SUBSCRIBE
> >  Content-Length: 0
> >
> > will not bet interpreted as an INVITE request. Also Request-URI must start with an alphabetic character.
> >
> > Confirm with RFC 3261
> >  Request-Line   =  Method SP Request-URI SP SIP-Version CRLF
> >
> > Signed-off-by: Ulrich Weber <ulrich.weber@riverbed.com>
> 
> Looks ok to me.
> 
> Acked-by: Marco Angaroni <marcoangaroni@gmail.com>

Applied, thanks!
