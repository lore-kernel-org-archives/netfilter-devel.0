From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH xtables-addons] build: support for Linux 4.12
Date: Thu, 15 Jun 2017 11:57:56 +0200 (CEST)
Message-ID: <nycvar.YFH.7.76.1706151157510.26391@n3.vanv.qr>
References: <20170514161611.8498-1-ralph.sennhauser@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ralph Sennhauser <ralph.sennhauser@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:37556 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751016AbdFOKG1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Jun 2017 06:06:27 -0400
In-Reply-To: <20170514161611.8498-1-ralph.sennhauser@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2017-05-14 18:16, Ralph Sennhauser wrote:

>As a result of commit cc41c84b7e7f ("netfilter: kill the fake untracked
>conntrack objects") the helper nf_ct_is_untracked always returns false
>and commit ab8bc7ed864b ("netfilter: remove nf_ct_is_untracked") removes
>it all together.

Applied, thanks.
