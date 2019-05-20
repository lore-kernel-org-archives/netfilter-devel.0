Return-Path: <SRS0=v9tr=TU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DFF3C04AAC
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 20:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47A6020863
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 20:03:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="G0hpcoWp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfETUDC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 May 2019 16:03:02 -0400
Received: from mx1.riseup.net ([198.252.153.129]:33200 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbfETUDB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 May 2019 16:03:01 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 11F211A2EE7;
        Mon, 20 May 2019 13:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1558382581; bh=4JQUl5Nc+BamTvfsAzo4I8YwtEZY3SCSUsGEJUOBw8s=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=G0hpcoWpryk5HY8iEbKbr8fcVthXETucq78dSum+scmlEznYrYCSRAFkacoJIQqYy
         9ivnplozhcwbVJcxZ0VTay0ZmC8l4wMrAdk73cZKKG5X8xEqLayB3++Wm76Uiuefja
         Lt2d9x1Wl1LZZF5WEt2Xs2Mya4BttrLmeA7SyO3o=
X-Riseup-User-ID: 10A42944D4569B93233C6BA095F82BAAE7241179FF86CF57F66C84C0194C7807
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 2BF7B222F63;
        Mon, 20 May 2019 13:02:59 -0700 (PDT)
Date:   Mon, 20 May 2019 22:02:53 +0200
In-Reply-To: <20190520194833.g6zoy2zvqjmovv3u@breakpoint.cc>
References: <20190519205259.2821-1-ffmancera@riseup.net> <20190519205259.2821-3-ffmancera@riseup.net> <20190519211207.mi3mbgtjcsbijsve@breakpoint.cc> <0d96ae82-74b8-4c30-d684-1221d8b4fe44@riseup.net> <20190520194833.g6zoy2zvqjmovv3u@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH nf-next v2 2/4] netfilter: synproxy: remove module dependency on IPv6 SYNPROXY
To:     Florian Westphal <fw@strlen.de>
CC:     netfilter-devel@vger.kernel.org
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Message-ID: <7E3F3BB8-350D-4A77-927A-DC1128C488C9@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

El 20 de mayo de 2019 21:48:33 CEST, Florian Westphal <fw@strlen=2Ede> escr=
ibi=C3=B3:
>Fernando Fernandez Mancera <ffmancera@riseup=2Enet> wrote:
>> > ERROR: "ipv4_synproxy_hook" [net/ipv6/netfilter/ip6t_SYNPROXY=2Eko]
>undefined!
>> >    ERROR: "synproxy_send_client_synack_ipv6"
>[net/ipv6/netfilter/ip6t_SYNPROXY=2Eko] undefined!
>> >    ERROR: "synproxy_recv_client_ack_ipv6"
>[net/ipv6/netfilter/ip6t_SYNPROXY=2Eko] undefined!
>> >    ERROR: "nf_synproxy_ipv6_init"
>[net/ipv6/netfilter/ip6t_SYNPROXY=2Eko] undefined!
>> >    ERROR: "nf_synproxy_ipv6_fini"
>[net/ipv6/netfilter/ip6t_SYNPROXY=2Eko] undefined!
>> >    ERROR: "ipv4_synproxy_hook" [net/ipv4/netfilter/ipt_SYNPROXY=2Eko]
>undefined!
>> >    ERROR: "synproxy_send_client_synack"
>[net/ipv4/netfilter/ipt_SYNPROXY=2Eko] undefined!
>> >    ERROR: "synproxy_recv_client_ack"
>[net/ipv4/netfilter/ipt_SYNPROXY=2Eko] undefined!
>> >    ERROR: "nf_synproxy_ipv4_init"
>[net/ipv4/netfilter/ipt_SYNPROXY=2Eko] undefined!
>> >    ERROR: "nf_synproxy_ipv4_fini"
>[net/ipv4/netfilter/ipt_SYNPROXY=2Eko] undefined!
>>=20
>> Why undefined? I have exported them with EXPORT_SYMBOL_GPL()=2E What am
>I
>> missing? Thanks!
>
>The only cases I can think of are these:
>
>a) synproxy_send_client_synack_ipv6 etc=2E is not exported
>b) synproxy_send_client_synack_ipv6 are exported, but not built
>   (usually points to a dependency bug)=2E
>c) synproxy_send_client_synack_ipv6 are in a module, but foo=2Eo is
>builtin
>
>Above errors would hint at b)=2E You can check the =2Econfig if thats the
>case or not=2E

Thanks Florian, I will check them :-)
