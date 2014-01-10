From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: [PATCH libnftables] Add support for ct set
Date: Fri, 10 Jan 2014 14:19:42 +0100
Message-ID: <CAKfDRXgDZSnQ-cvpDTbea45ZTeFOMu_PThEp1kL-qNeQzVKrQw@mail.gmail.com>
References: <1389359425-6837-1-git-send-email-kristian.evensen@gmail.com>
	<20140110131406.GA8088@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:37299 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaAJNTn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:19:43 -0500
Received: by mail-pd0-f174.google.com with SMTP id x10so4588404pdj.33
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2014 05:19:42 -0800 (PST)
In-Reply-To: <20140110131406.GA8088@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Fri, Jan 10, 2014 at 2:14 PM, Patrick McHardy <kaber@trash.net> wrote:
> nftables uses statements for things that don't return a value. I think
> it would make sense to keep this consistent. An "set" expression (aka
> statement) can never be used in a match, so its something fundamentally
> different than an expression.

Are you discussing the removal of the union?

-Kristian
