From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter, kbuild: use canonical method to specify objs.
Date: Mon, 19 Jun 2017 19:12:07 +0200
Message-ID: <20170619171207.GA5037@salvia>
References: <1496396137-22173-1-git-send-email-jike.song@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Jike Song <jike.song@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56836 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751757AbdFSRMQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2017 13:12:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3292D2E7849
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 19:12:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27A3D102182
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 19:12:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3F47FFF6DE
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 19:12:04 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1496396137-22173-1-git-send-email-jike.song@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 02, 2017 at 05:35:37PM +0800, Jike Song wrote:
> Should use ":=" instead of "+=".

Applied, thanks.
