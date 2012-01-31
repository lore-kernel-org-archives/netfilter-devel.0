From: Cao Xuan Sang <sangkao@gmail.com>
Subject: Re: Alter TCP packet not work fine with netfilter hook
Date: Tue, 31 Jan 2012 11:46:13 +0700
Message-ID: <CANopevXXq8Moz2mM0+EExapCAv+va-Q6qv7=UMXpaQZV_AF3og@mail.gmail.com>
References: <CANopevWckbSuu2jys5BjCLLU6TF0FHZNgK8SgbY2PAEpRuxQmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56374 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab2AaEqe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jan 2012 23:46:34 -0500
Received: by bkcjm19 with SMTP id jm19so163203bkc.19
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Jan 2012 20:46:33 -0800 (PST)
In-Reply-To: <CANopevWckbSuu2jys5BjCLLU6TF0FHZNgK8SgbY2PAEpRuxQmw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Hi netfilter family,
> I'm a newbie to netfilter.
> I have just developt a crypto module using netfilter hook.
> In this module :
> SENDER : IP payload will be encrypted at POST ROUTING hook
> RECEIVE : IP payload wil be decrypted at PRE ROUTING hook.
>
> The module work fine with ICMP & UDP but it NOT work fine with TCP: 2 machine still receive packet at hook but application not communicate together.
>
> I don't know whether any mystery in netfilter or linux network kernel at here?
>
> Thanks :)
