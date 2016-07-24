From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ISSUE] nftables: !=range doesn't really work
Date: Sun, 24 Jul 2016 12:58:41 +0200
Message-ID: <20160724105841.GB17882@salvia>
References: <CADvbK_e1GPX+jBDfDgAAppYaT-51HEpVxqr7ssC1O+Yf02QKJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Xin Long <lucien.xin@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33410 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbcGXK6z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Jul 2016 06:58:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 79B0DC510D
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Jul 2016 12:58:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6AAC4FEFBF
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Jul 2016 12:58:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EFEA59D5BE
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Jul 2016 12:58:50 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CADvbK_e1GPX+jBDfDgAAppYaT-51HEpVxqr7ssC1O+Yf02QKJA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Sun, Jul 24, 2016 at 04:17:49PM +0800, Xin Long wrote:
> nftable transform 'x !=a-b' in wrong way:
> cmp x < a
> cmp x > b
> 
> which means x has to be x<a && x>b.
> but it should be x<a || x>b.
> 
> It seems that the vm system in kernel is too simple and fast
> to provide some expr or process for this case, afaics.
> 
> does upstream have been preparing some fix for this ?

Will be sending a fix for this asap.
