From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 1/4] netfilter: nf_tables: get rid of jump
 label to return
Date: Mon, 1 May 2017 12:55:06 +0200
Message-ID: <20170501105506.GA24755@salvia>
References: <1493629083-2847-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51912 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934060AbdEAKzS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 May 2017 06:55:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 633E4210561
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 12:55:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 552D8DA870
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 12:55:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 43191FC3DB
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 12:55:10 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1493629083-2847-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

BTW, I'll be routing this patchset through nf.git, this depends on a
fix from Liping Zhang. Just to keep it simple, this batch is
nevertheless coming with two fixes.
