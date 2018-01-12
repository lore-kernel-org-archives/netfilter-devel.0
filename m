From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables v2] extensions: add support for 'srh' match
Date: Fri, 12 Jan 2018 01:24:48 +0100
Message-ID: <20180112002448.b3jscp6f4nmupbmr@salvia>
References: <1515690761-4836-1-git-send-email-amsalam20@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
To: Ahmed Abdelsalam <amsalam20@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43180 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753877AbeALAYy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Jan 2018 19:24:54 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2B1964DE721
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Jan 2018 01:24:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1A714DA847
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Jan 2018 01:24:53 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1515690761-4836-1-git-send-email-amsalam20@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 11, 2018 at 06:12:41PM +0100, Ahmed Abdelsalam wrote:
> This patch adds a new exetension to iptables to supprt 'srh' match
> The implementation considers revision 7 of the SRH draft.
> https://tools.ietf.org/html/draft-ietf-6man-segment-routing-header-07

Applied, thanks Ahmed.
