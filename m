Return-Path: <SRS0=4AXv=6N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F3B3C83003
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Apr 2020 13:28:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8575B2074A
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Apr 2020 13:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgD2N2q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Apr 2020 09:28:46 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:42660 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726822AbgD2N2q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Apr 2020 09:28:46 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 999CA3A3E93
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 23:28:41 +1000 (AEST)
Received: (qmail 6192 invoked by uid 501); 29 Apr 2020 13:28:40 -0000
Date:   Wed, 29 Apr 2020 23:28:40 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnetfilter_queue 0/3] pktbuff API updates
Message-ID: <20200429132840.GA3833@dimstar.local.net>
Mail-Followup-To: Netfilter Development <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20200426132356.8346-1-pablo@netfilter.org>
 <20200427110614.GA15436@dimstar.local.net>
 <20200427170656.GA22296@salvia>
 <20200428043302.GB15436@dimstar.local.net>
 <20200428103407.GA1160@salvia>
 <20200428211452.GF15436@dimstar.local.net>
 <20200428225520.GA30421@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428225520.GA30421@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=RSmzAf-M6YYA:10
        a=jzDLcpIwrM0rSJFAthMA:9 a=2B490EoPkbpD0fp3:21 a=Mgaw800el5y-MoP5:21
        a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 29, 2020 at 12:55:20AM +0200, Pablo Neira Ayuso wrote:
> On Wed, Apr 29, 2020 at 07:14:52AM +1000, Duncan Roe wrote:
> > On Tue, Apr 28, 2020 at 12:34:07PM +0200, Pablo Neira Ayuso wrote:
> [...]
> > > pktb_alloc2() still has a memcpy which is not needed by people that do
> > > not need to mangle the packet.
> >
> > No it does not. Please look again. There is only a memcpy if the caller
> > specifies extra > 0, in which case she clearly intends to mangle it (perhaps
> > depending on its contents).
>
> Right, it only happens if extra is specified.
>
> +       if (extra) {
> +               pkt_data = buf;
> +               memcpy(pkt_data, data, len);
> +               memset((uint8_t *)pkt_data + len, 0, extra);
> +       } else {
> +               pkt_data = data;
> +       }
>
> So buf is only used if extra is specified?

Yes, that's right.
>
> > "depending on its contents" is where the memcpy deferral comes in. pktb_alloc2()
> > verifies that the supplied buffer is big enough (size >= len + extra). The user
> > declared it as a stack variable that size so it will be. With the deferral
> > enhancement, pktb_alloc2() records the buffer address and extra in the enlarged
> > struct pktbuff (extra is needed to tell pktb_mangle how much memory to memset to
> > 0).
>
> I agree that deferring the memcpy() and avoiding the malloc() is the
> way to go, we only have to agree in the way to achieve this.
>
> > If pktb_mangle() finds it has to make the packet larger then its original length
> > and the packet is still in its original location then copy it and zero extra.
> > (i.e. pktb_mangle() doesn't just check whether it was asked to make the packet
> > bigger: it might have previously been asked to make it smaller).
> >
> > Also (and this *is* tricky, update relevant pointers in the struct pktbuff).
> > That invalidates any poiners the caller may have obtained from e.g. pktb_data()
> > - see end of email.
>
> Regarding pktb_mangle() reallocation case, refetching the pointers
> sounds fine, documenting this is sufficient.
>
> [...]
> > > Revisiting, I would prefer to keep things simple. The caller should
> > > make sure that pktb_mangle() has a buffer containing enough room. I
> > > think it's more simple for the caller to allocate a buffer that is
> > > large enough for any mangling.

I reckon they'll just copy the code from the nfq_nlmsg_verdict_put_pkt() man /
web page. After declaring "char pktbuf[plen + EXTRA];" one can use "sizeof
pktbuf" as the length argument.
> >
> > Yes it's more complex. No problem with the buffer - the user gave that to
> > pktb_alloc2().
>
> I'm just hesitating about the new pktb_alloc2() approach because it
> has many parameters, it's just looks a bit complicated to me (this
> function takes 8 parameters).

It has the original 4 from pktb_alloc() plus 2 {buffer, size} pairs. It could
have been just one pair, with packet data appended to metadata as in
pktb_alloc() but I thought it would be really awkward to document how to
dimension it.
>
> If you can just pre-allocate the pkt_buff head from the configuration
> phase (before receiving packets from the kernel), then attach the
> buffer via pktb_setup_metadata() for each packet that is received (so
> the pkt_buff head is recycled). With this approach, pktb_head_size()
> won't be needed either.

I think we should not be usurping the data pointer of mnl_cb_run(). I can see
people wanting to use it to pass a pointer to e.g. some kind of database that
callbacks need to access. There's no performance gain to recycling the buffer:
the CB doesn't need to call pktb_head_size() on every invocation, that can be
done once by main() e.g.

 static size_t sizeof_head;
 ...
 int main(int argc, char *argv[])
 {
 ...
         sizeof_head = pktb_head_size(); /* Avoid multiple calls in CB */
 ...
 static int queue_cb(const struct nlmsghdr *nlh, void *data)
 {
         char head[sizeof_head];

>
> My understanding is that requirements are:
>
> * Users that do not want to mangle the packet, they use the buffer
>   that was passed to recvmsg().
> * Users that want to mangle the packet, they use the _mangle()
>   function that might reallocate the data buffer (the one you would
>   like to have). However, if this data buffer reallocation happens,
>   then pkt_buff should annotate that this pkt_buff object needs to
>   release this data buffer from pktb_free() otherwise.

No, there is nothing to release. We told pktb_alloc2() where the buffer was,
it's on the stack (usually).
>
> > Problem is that if mangler moves the packet, then any packet pointer the caller
> > had is invalid (points to the un-mangled copy). This applies at all levels, e.g.
> > nfq_udp_get_payload(). There is no way for the mangler functions to address
> > this: it just has to be highlighted in the documentation.
>
> That's fine, this is exactly how the kernel works: if the function
> might reallocate the data area, then you have to refetch pointers
> after this. If you teach _mangle() to do reallocations, then
> documenting this is fine.
>
> However, those reallocation need pktb_free() to release that new data
> buffer, right?

No way. There is no malloc() nor free() anywhere. The data buffer is
(recommended to be) on the stack; for running under gdb it may be preferred to
us a static buffer which has to be dimensioned hugely.
>
> > Still, I really like the deferred copy enhancement. Your thoughts?
>
> The deferred copy idea when mangling sounds fine, we only have to
> agree on how to get this done.
>
> Thanks.

Cheers ... Duncan.
