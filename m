From: Xin Long <lucien.xin@gmail.com>
Subject: [ISSUE] nftables: !=range doesn't really work
Date: Sun, 24 Jul 2016 16:17:49 +0800
Message-ID: <CADvbK_e1GPX+jBDfDgAAppYaT-51HEpVxqr7ssC1O+Yf02QKJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:35924 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbcGXIRv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Jul 2016 04:17:51 -0400
Received: by mail-qk0-f182.google.com with SMTP id x1so134007499qkb.3
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Jul 2016 01:17:51 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nftable transform 'x !=a-b' in wrong way:
cmp x < a
cmp x > b

which means x has to be x<a && x>b.
but it should be x<a || x>b.

It seems that the vm system in kernel is too simple and fast
to provide some expr or process for this case, afaics.

does upstream have been preparing some fix for this ?
