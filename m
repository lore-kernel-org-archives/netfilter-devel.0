Return-Path: <SRS0=Ro/3=TA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7CF3C43219
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Apr 2019 12:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF124205ED
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Apr 2019 12:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfD3MOH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Apr 2019 08:14:07 -0400
Received: from mail.us.es ([193.147.175.20]:40210 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726873AbfD3MOH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Apr 2019 08:14:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3FD7011FBF7
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2019 14:14:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2DA8FDA703
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2019 14:14:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 28922DA704; Tue, 30 Apr 2019 14:14:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1A4F3DA704;
        Tue, 30 Apr 2019 14:14:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 30 Apr 2019 14:14:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (129.166.216.87.static.jazztel.es [87.216.166.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D368B4265A31;
        Tue, 30 Apr 2019 14:14:02 +0200 (CEST)
Date:   Tue, 30 Apr 2019 14:14:02 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     a@juaristi.eus
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd2,v2 1/2] IPFIX: Add IPFIX output plugin
Message-ID: <20190430121402.vekqhlaxrnvgjzun@salvia>
References: <20190426075807.7528-1-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426075807.7528-1-a@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 26, 2019 at 09:58:06AM +0200, a@juaristi.eus wrote:
> From: Ander Juaristi <a@juaristi.eus>
> 
> This patch adds an IPFIX output plugin to ulogd2. It generates NetFlow/IPFIX
> traces and sends them to a remote server (collector) via TCP or UDP.
> 
> Based on original work by Holger Eitzenberger <holger@eitzenberger.org>.
> 
> How to test this
> ----------------
> 
> I am currently testing this with the NFCT input and Wireshark.
> 
> Place the following in ulogd.conf:
> 
>       # this will print all flows on screen
>       loglevel=1
> 
>       # load NFCT and IPFIX plugins
>       plugin="/lib/ulogd/ulogd_inpflow_NFCT.so"
>       plugin="/lib/ulogd/ulogd_output_IPFIX.so"
> 
>       stack=ct1:NFCT,ipfix1:IPFIX
> 
>       [ct1]
>       netlink_socket_buffer_size=217088
>       netlink_socket_buffer_maxsize=1085440
>       accept_proto_filter=tcp,sctp
> 
>       [ipfix1]
>       oid=1
>       host="127.0.0.1"
>       #port=4739
>       #send_template="once"
> 
> I am currently testing it by launching a plain NetCat listener on port
> 4739 (the default for IPFIX) and then running Wireshark and see that it
> dissects the IPFIX/NetFlow traffic correctly (obviously this relies on
> the Wireshark NetFlow dissector being correct).
> 
> First:
> 
>       nc -vvvv -l 127.0.0.1 4739
> 
> Then:
> 
>       sudo ulogd -vc ulogd.conf

Applied, thanks.
