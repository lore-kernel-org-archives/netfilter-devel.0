From: Kevin Cernekee <cernekee@chromium.org>
Subject: Re: Snooping expected connections in a user CT helper
Date: Thu, 8 Sep 2016 15:02:13 -0700
Message-ID: <CAJzqFtZ0TGb3HtFLRzWxrjN7Un0zz_ioWPEQx1SzVZF2urgEig@mail.gmail.com>
References: <CAJzqFtacjKi+zQT3nS_0UJAr=LD8RWumM5+jeo8bbi-OVZR0Jg@mail.gmail.com>
 <20160818011214.GA1463@salvia> <CAJzqFtaj3V2viTtNjhoG5zPsz0XkPXi9XULRwz1PGOe3imq_XA@mail.gmail.com>
 <20160823153610.GA10746@salvia> <CAJzqFtaRHOLUG=Fma+A_0gOe3E3AUzheK4x7_t-2e+eebrpZtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:38714 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932233AbcIHWCj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Sep 2016 18:02:39 -0400
Received: by mail-it0-f53.google.com with SMTP id c198so978014ith.1
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Sep 2016 15:02:38 -0700 (PDT)
Received: from mail-oi0-f51.google.com (mail-oi0-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id p130sm73549oia.16.2016.09.08.15.02.33
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Sep 2016 15:02:35 -0700 (PDT)
Received: by mail-oi0-f51.google.com with SMTP id x125so40919894oia.3
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Sep 2016 15:02:33 -0700 (PDT)
In-Reply-To: <CAJzqFtaRHOLUG=Fma+A_0gOe3E3AUzheK4x7_t-2e+eebrpZtg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 1, 2016 at 4:47 PM, Kevin Cernekee <cernekee@chromium.org> wrote:
> The patch that I sent out last night is able to handle scenarios in
> which the event occurs shortly after the subscription is established.
> But in my testing I am noticing two other problems:
>
> 1) Approximately two minutes after the subscription is set up, the
> expectation abruptly disappears.  This even happens if I set the
> timeout to 3600; it shows up in `conntrack -L expect` until the time
> column drops to ~3480, then it is gone.  This may be caused by the
> master conntrack expiring.  Is there a way to set up the expectation
> so that it persists for the entire timeout period?
>
> 2) The timeout is not extended when there is activity on the
> expectation.  It would be good if it was extended any time there is
> new activity, in order to support long-lived subscriptions.

Friendly ping...

Do you think I'm on the right track with this approach, and if so,
what is the best way to establish long-lived expectations for UPnP?

http://marc.info/?l=netfilter-devel&m=147270416910580&w=2

Thanks.
