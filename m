From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] tests: xlate: print tests passed and error for
 testfile argument
Date: Tue, 17 Oct 2017 14:44:21 +0200
Message-ID: <20171017124421.GA20525@salvia>
References: <20171017092458.18672-1-harshasharmaiitr@gmail.com>
 <20171017112757.GA8578@salvia>
 <CANMOCy0HPn+0v62=-rBqZzLFq9V28VswQDeW2x-MDofXDCt+Eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        outreachy-kernel <outreachy-kernel@googlegroups.com>
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55072 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755019AbdJQMo1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 08:44:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0856B5230A
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 14:44:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE291DA874
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 14:44:24 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CANMOCy0HPn+0v62=-rBqZzLFq9V28VswQDeW2x-MDofXDCt+Eg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 17, 2017 at 06:11:20PM +0530, Harsha Sharma wrote:
> On Tue, Oct 17, 2017 at 4:57 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Oct 17, 2017 at 02:54:58PM +0530, Harsha Sharma wrote:
> >> Print tests passed with errors and warnings when run with only specified
> >> test file.
> >
> > I would expect this works like this, for consistency with other test
> > infrastructure we have:
> >
> > # python xlate-test.py extensions/libxt_ecn.txlate
> > Error: test file does not exist
> >
> > I can see here this works like this:
> >
> > # python xlate-test.py libxt_ecn.txlate
> >
> > But as said, it is counterintuitive. Would you revisit this patch?
> What I have tried to do int this patch is
> for e.g.
> 
> # sudo python xlate-test.py libxt_ecn.txlate
> will not result into any output as all tests are passed
> but with this patch
> # sudo python xlate-test.py libxt_ecn.txlate  (gives output)
> ## libxt_ecn
> Ok
> src: iptables-translate -A INPUT -m ecn --ecn-ip-ect 0
> res: nft add rule ip filter INPUT ip ecn not-ect counter
> 
> Ok
> src: iptables-translate -A INPUT -m ecn --ecn-ip-ect 1
> res: nft add rule ip filter INPUT ip ecn ect1 counter
> 
> which is expected output as one should get to know if the tests are passed
> or not .
>
> Thanks. Please let me know if this is expected output or not.

I see, thanks for explaining.

I would prefer you make this converge with the output of
iptables-test.py. It would be great if you can update the
xlate-tests.py so the output looks the same.

Thanks!
