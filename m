From: Daniel Collins <daniel.collins@smoothwall.net>
Subject: NFQUEUE panic bug
Date: Fri, 29 Jul 2016 13:09:00 +0100
Message-ID: <CAOmdcgVGCZnoGCu1B4Z5w_EQLDLyfm==6fVvTttgZBqPGxuPeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:37779 "EHLO
	mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbcG2MJD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Jul 2016 08:09:03 -0400
Received: by mail-it0-f41.google.com with SMTP id f6so105912547ith.0
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jul 2016 05:09:02 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi

I've found a race condition which allows remotely triggering a kernel
panic, should I post the details to this list, or somewhere else?

Thanks

-- 

Daniel Collins
Developer

www.smoothwall.com

Office : +44 148-988-6073

Head Office : Avalon, 1 Savannah Way, Leeds, LS10 1AB, United Kingdom
Tech Office : Eagle Point, Little Park Farm Road, Fareham, PO15 5TD,
United Kingdom
US Office : 8008 Corporate Center Dr #410, Charlotte, NC 28226, United States

Telephone: UK: +44 870-199-9500 US: +1 800-959-3760

Smoothwall Limited is registered in England, Company Number: 4298247
and whose registered address is 1 John Charles Way, Leeds, LS12 6QA
United Kingdom.
