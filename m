Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B10EC83000
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 22:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11A1E2070B
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 22:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbgD1WzZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 18:55:25 -0400
Received: from correo.us.es ([193.147.175.20]:36872 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbgD1WzY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 18:55:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EAC1A130E26
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 00:55:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D7BB4BAAB1
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 00:55:22 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CD68BBAAAF; Wed, 29 Apr 2020 00:55:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CBA8E2067A
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 00:55:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 Apr 2020 00:55:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id AB53C42EF4E0
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 00:55:20 +0200 (CEST)
Date:   Wed, 29 Apr 2020 00:55:20 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue 0/3] pktbuff API updates
Message-ID: <20200428225520.GA30421@salvia>
References: <20200426132356.8346-1-pablo@netfilter.org>
 <20200427110614.GA15436@dimstar.local.net>
 <20200427170656.GA22296@salvia>
 <20200428043302.GB15436@dimstar.local.net>
 <20200428103407.GA1160@salvia>
 <20200428211452.GF15436@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428211452.GF15436@dimstar.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 29, 2020 at 07:14:52AM +1000, Duncan Roe wrote:
> On Tue, Apr 28, 2020 at 12:34:07PM +0200, Pablo Neira Ayuso wrote:
[...]
> > pktb_alloc2() still has a memcpy which is not needed by people that do
> > not need to mangle the packet.
> 
> No it does not. Please look again. There is only a memcpy if the caller
> specifies extra > 0, in which case she clearly intends to mangle it (perhaps
> depending on its contents).

Right, it only happens if extra is specified.

+       if (extra) {
+               pkt_data = buf;
+               memcpy(pkt_data, data, len);
+               memset((uint8_t *)pkt_data + len, 0, extra);
+       } else {
+               pkt_data = data;
+       }

So buf is only used if extra is specified?

> "depending on its contents" is where the memcpy deferral comes in. pktb_alloc2()
> verifies that the supplied buffer is big enough (size >= len + extra). The user
> declared it as a stack variable that size so it will be. With the deferral
> enhancement, pktb_alloc2() records the buffer address and extra in the enlarged
> struct pktbuff (extra is needed to tell pktb_mangle how much memory to memset to
> 0).

I agree that deferring the memcpy() and avoiding the malloc() is the
way to go, we only have to agree in the way to achieve this.

> If pktb_mangle() finds it has to make the packet larger then its original length
> and the packet is still in its original location then copy it and zero extra.
> (i.e. pktb_mangle() doesn't just check whether it was asked to make the packet
> bigger: it might have previously been asked to make it smaller).
>
> Also (and this *is* tricky, update relevant pointers in the struct pktbuff).
> That invalidates any poiners the caller may have obtained from e.g. pktb_data()
> - see end of email.

Regarding pktb_mangle() reallocation case, refetching the pointers
sounds fine, documenting this is sufficient.

[...]
> > Revisiting, I would prefer to keep things simple. The caller should
> > make sure that pktb_mangle() has a buffer containing enough room. I
> > think it's more simple for the caller to allocate a buffer that is
> > large enough for any mangling.
> 
> Yes it's more complex. No problem with the buffer - the user gave that to
> pktb_alloc2().

I'm just hesitating about the new pktb_alloc2() approach because it
has many parameters, it's just looks a bit complicated to me (this
function takes 8 parameters).

If you can just pre-allocate the pkt_buff head from the configuration
phase (before receiving packets from the kernel), then attach the
buffer via pktb_setup_metadata() for each packet that is received (so
the pkt_buff head is recycled). With this approach, pktb_head_size()
won't be needed either.

My understanding is that requirements are:

* Users that do not want to mangle the packet, they use the buffer
  that was passed to recvmsg().
* Users that want to mangle the packet, they use the _mangle()
  function that might reallocate the data buffer (the one you would
  like to have). However, if this data buffer reallocation happens,
  then pkt_buff should annotate that this pkt_buff object needs to
  release this data buffer from pktb_free() otherwise.

> Problem is that if mangler moves the packet, then any packet pointer the caller
> had is invalid (points to the un-mangled copy). This applies at all levels, e.g.
> nfq_udp_get_payload(). There is no way for the mangler functions to address
> this: it just has to be highlighted in the documentation.

That's fine, this is exactly how the kernel works: if the function
might reallocate the data area, then you have to refetch pointers
after this. If you teach _mangle() to do reallocations, then
documenting this is fine.

However, those reallocation need pktb_free() to release that new data
buffer, right?

> Still, I really like the deferred copy enhancement. Your thoughts?

The deferred copy idea when mangling sounds fine, we only have to
agree on how to get this done.

Thanks.
