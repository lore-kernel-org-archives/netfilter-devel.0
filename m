From: David Buchmann <david@jazznetworks.com>
Subject: nfqueue: Get pid of socket owner
Date: Mon, 7 Nov 2016 15:21:34 +0100
Message-ID: <71D00C03-A2AD-4836-8F5F-724AECE75DE6@jazznetworks.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:33852 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751541AbcKGOVh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Nov 2016 09:21:37 -0500
Received: by mail-lf0-f46.google.com with SMTP id o141so42519170lff.1
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Nov 2016 06:21:36 -0800 (PST)
Received: from [10.80.125.56] ([85.221.54.211])
        by smtp.gmail.com with ESMTPSA id 69sm5177677lfq.39.2016.11.07.06.21.34
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 07 Nov 2016 06:21:34 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I've started work to add support in the nfnetlink_queue kernel module =
for
sending the pid of the process owning the socket triggering nfqueue, and =
I
want to add the userspace support in libnetfilter_queue, but before I =
get
too invested in that work I just want to check whether there are any
objections to such a feature in either the kernel or in the
libnetfilter_queue library?

=
https://github.com/wuurrd/linux/commit/79d12e93ca2a28c0939937a5a690943311e=
4bf6c

David=
