From: Derick Winkworth <ccie15672@gmail.com>
Subject: Generic NAT helper module using NetPDL
Date: Mon, 5 Mar 2012 16:56:40 -0600
Message-ID: <CANavrTPs1TH121sC5K+8OBLXBJ+Y6JMMpJ2EKgpvzPZQ75gtyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42676 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab2CEW4l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Mar 2012 17:56:41 -0500
Received: by bkcik5 with SMTP id ik5so3705580bkc.19
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Mar 2012 14:56:40 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

All:

I was wondering if anyone has tried do something like this before.
Given a way to describe the payload of a TCP or UDP packet for a given
protocol using XML, and I'm specifically thinking of NetPDL, could a
generic NAT helper module be built that could read in those
descriptions to perform the requisite NAT?

I'm thinking this could even be done live.  Place the xml file into a
directory and within 5 minutes or whatever, it could be read in and
the traffic for that protocol could potentially be processed as
required for NAT...

It would be easier I think going forward to add ALG support in general
(could be used for connection tracking as well).  No need to code the
module in C.

I'm not saying it would be "easy" but I think its possible...

Derick
