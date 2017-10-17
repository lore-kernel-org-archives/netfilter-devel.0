From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: Re: [PATCH v2] tests: xlate: print tests passed and error for
 testfile argument
Date: Tue, 17 Oct 2017 18:11:20 +0530
Message-ID: <CANMOCy0HPn+0v62=-rBqZzLFq9V28VswQDeW2x-MDofXDCt+Eg@mail.gmail.com>
References: <20171017092458.18672-1-harshasharmaiitr@gmail.com> <20171017112757.GA8578@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org,
        outreachy-kernel <outreachy-kernel@googlegroups.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:43045 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753221AbdJQMlV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 08:41:21 -0400
Received: by mail-vk0-f66.google.com with SMTP id t203so985524vke.0
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 05:41:21 -0700 (PDT)
In-Reply-To: <20171017112757.GA8578@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 17, 2017 at 4:57 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Oct 17, 2017 at 02:54:58PM +0530, Harsha Sharma wrote:
>> Print tests passed with errors and warnings when run with only specified
>> test file.
>
> I would expect this works like this, for consistency with other test
> infrastructure we have:
>
> # python xlate-test.py extensions/libxt_ecn.txlate
> Error: test file does not exist
>
> I can see here this works like this:
>
> # python xlate-test.py libxt_ecn.txlate
>
> But as said, it is counterintuitive. Would you revisit this patch?
What I have tried to do int this patch is
for e.g.

# sudo python xlate-test.py libxt_ecn.txlate
will not result into any output as all tests are passed
but with this patch
# sudo python xlate-test.py libxt_ecn.txlate  (gives output)
## libxt_ecn
Ok
src: iptables-translate -A INPUT -m ecn --ecn-ip-ect 0
res: nft add rule ip filter INPUT ip ecn not-ect counter

Ok
src: iptables-translate -A INPUT -m ecn --ecn-ip-ect 1
res: nft add rule ip filter INPUT ip ecn ect1 counter

which is expected output as one should get to know if the tests are passed
or not .

Thanks. Please let me know if this is expected output or not.
>
> Thanks.
