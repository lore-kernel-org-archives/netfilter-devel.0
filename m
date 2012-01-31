From: nt pm <ntph.minh@gmail.com>
Subject: Alter TCP packet not work fine with netfilter hook
Date: Tue, 31 Jan 2012 11:50:01 +0700
Message-ID: <CAF4uzgWbtvmyum-5tmfjmWKQi6ev=+=O52ENvq9png=jhdpiGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51652 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab2AaEuD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jan 2012 23:50:03 -0500
Received: by qcqw6 with SMTP id w6so99048qcq.19
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Jan 2012 20:50:01 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi netfilter family,
I'm a newbie to netfilter.
I have just developt a crypto module using netfilter hook.
In this module :
SENDER : IP payload will be encrypted at POST ROUTING hook
RECEIVE : IP payload wil be decrypted at PRE ROUTING hook.

The module work fine with ICMP & UDP but it NOT work fine with TCP: 2
machine still receive packet at hook but application not communicate
together.

I don't know whether any mystery in netfilter or linux network kernel at here?

Thanks :)
