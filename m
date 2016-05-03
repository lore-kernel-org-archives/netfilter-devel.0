From: Joe Stringer <joe@ovn.org>
Subject: Re: [PATCH nf-next 4/4] openvswitch: __nf_ct_l{3,4}proto_find()
 always return a valid pointer
Date: Tue, 3 May 2016 15:12:32 -0700
Message-ID: <CAPWQB7EFT2s9A-iFG3LGKuopz3hKFQBWeGthhBg7W_=qXvL8Cw@mail.gmail.com>
References: <1462272863-23946-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org, ovs dev <dev@openvswitch.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:50087 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527AbcECWM4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 May 2016 18:12:56 -0400
Received: from mfilter10-d.gandi.net (mfilter10-d.gandi.net [217.70.178.139])
	by relay5-d.mail.gandi.net (Postfix) with ESMTP id 0B5A341C088
	for <netfilter-devel@vger.kernel.org>; Wed,  4 May 2016 00:12:55 +0200 (CEST)
Received: from relay5-d.mail.gandi.net ([IPv6:::ffff:217.70.183.197])
	by mfilter10-d.gandi.net (mfilter10-d.gandi.net [::ffff:10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id kT5uyMp5voaW for <netfilter-devel@vger.kernel.org>;
	Wed,  4 May 2016 00:12:53 +0200 (CEST)
Received: from mail-oi0-f50.google.com (mail-oi0-f50.google.com [209.85.218.50])
	(Authenticated sender: joe@ovn.org)
	by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 827EF41C086
	for <netfilter-devel@vger.kernel.org>; Wed,  4 May 2016 00:12:53 +0200 (CEST)
Received: by mail-oi0-f50.google.com with SMTP id k142so44350950oib.1
        for <netfilter-devel@vger.kernel.org>; Tue, 03 May 2016 15:12:53 -0700 (PDT)
In-Reply-To: <1462272863-23946-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 3 May 2016 at 03:54, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> If the protocol is not natively supported, this assigns generic protocol
> tracker so we can always assume a valid pointer after these calls.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks for the cleanup.

Acked-by: Joe Stringer <joe@ovn.org>
