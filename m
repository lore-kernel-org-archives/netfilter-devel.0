From: James Feeney <james@nurealm.net>
Subject: Re: reject statement - "crazy" parse error?
Date: Fri, 28 Oct 2016 13:16:09 -0600
Message-ID: <e77de0f5-4d89-f634-1e97-766585bbc676@nurealm.net>
References: <aea0c58c-dd68-bffb-859c-81f77ebe8dfd@nurealm.net>
 <CAOkSjBjd6CwTcMv_G1p1KmWnQukHUn6f4oCoaeZHmXEyJDiW4g@mail.gmail.com>
 <5a8da546-8694-40b8-b514-1f80bff71a44@nurealm.net>
 <CAOkSjBgd0UJzg3Xp-ub4twebDmHdVJ25e5GkWEw5h2XUmQxKxQ@mail.gmail.com>
Reply-To: james@nurealm.net
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:51481 "EHLO
        resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753174AbcJ1TQM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Oct 2016 15:16:12 -0400
In-Reply-To: <CAOkSjBgd0UJzg3Xp-ub4twebDmHdVJ25e5GkWEw5h2XUmQxKxQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hmm - something else I just noticed, with test.nft as the example - the problem
only occurs with the prerouting and postrouting hooks.

There is no error when using the input, forward, or output hooks.
