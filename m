From: Joe Stringer <joe@ovn.org>
Subject: Re: [PATCH nf-next] netfilter: nf_ct_helper: disable automatic helper assignment
Date: Tue, 3 May 2016 15:21:00 -0700
Message-ID: <CAPWQB7EyGi2XpfS9LAnwBf7eNjiPDwC_FVnxAW_4iYHrp9NObg@mail.gmail.com>
References: <1460646821-15401-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:54019 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519AbcECWVY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 May 2016 18:21:24 -0400
Received: from mfilter42-d.gandi.net (mfilter42-d.gandi.net [217.70.178.172])
	by relay5-d.mail.gandi.net (Postfix) with ESMTP id 6AFE341C088
	for <netfilter-devel@vger.kernel.org>; Wed,  4 May 2016 00:21:22 +0200 (CEST)
Received: from relay5-d.mail.gandi.net ([IPv6:::ffff:217.70.183.197])
	by mfilter42-d.gandi.net (mfilter42-d.gandi.net [::ffff:10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id keA_Lw4F9h9Z for <netfilter-devel@vger.kernel.org>;
	Wed,  4 May 2016 00:21:21 +0200 (CEST)
Received: from mail-oi0-f50.google.com (mail-oi0-f50.google.com [209.85.218.50])
	(Authenticated sender: joe@ovn.org)
	by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id C93E741C08D
	for <netfilter-devel@vger.kernel.org>; Wed,  4 May 2016 00:21:20 +0200 (CEST)
Received: by mail-oi0-f50.google.com with SMTP id v145so44441624oie.0
        for <netfilter-devel@vger.kernel.org>; Tue, 03 May 2016 15:21:20 -0700 (PDT)
In-Reply-To: <1460646821-15401-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14 April 2016 at 08:13, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Four years ago we introduced a new sysctl knob to disable automatic
> helper assignment in 72110dfaa907 ("netfilter: nf_ct_helper: disable
> automatic helper assignment"). This knob kept this behaviour enabled by
> default to remain conservative.

Presumably you mean a9006892643a ("netfilter: nf_ct_helper: allow to
disable automatic helper assignment").

Otherwise, LGTM.
