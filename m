From: Justin Yaple <yaplej@gmail.com>
Subject: Anyway to add data to connection tracking?
Date: Mon, 19 Apr 2010 12:40:41 -0700
Message-ID: <i2y8363055a1004191240jeb1bb313r3f414cdc89b0468e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.211.194]:37404 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab0DSTkl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Apr 2010 15:40:41 -0400
Received: by ywh32 with SMTP id 32so2890452ywh.33
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Apr 2010 12:40:41 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi everyone,

I am working on an application that has to track data within
custom/non-standard TCP options within the packets of each TCP
session.  It has to check the existence of, and examine the data
within these options then save that data about the session somewhere.
I had previously written my own session tracking system using a large
jump table to linked lists of a custom session structure in case of
collisions with my hashing function.

I was wondering if its possible to use conntrack for this rather than
re-invent the wheel.  My application needs to be alerted when a
session is being removed from the conntrack table so it can cleanup
any data related to that session within the program.  Given the
particular requirements I was not sure if the existing conntrack table
would be suitable for doing this.

What are your though on trying to use conntrack vs using an internal
connection tracking method within the application?

-Justin.
