Return-Path: <SRS0=4AXv=6N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FD64C83000
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Apr 2020 19:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4107E206D9
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Apr 2020 19:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgD2TyS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Apr 2020 15:54:18 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48896 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726456AbgD2TyR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Apr 2020 15:54:17 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id B3003820A65
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2020 05:54:14 +1000 (AEST)
Received: (qmail 7526 invoked by uid 501); 29 Apr 2020 19:54:14 -0000
Date:   Thu, 30 Apr 2020 05:54:14 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue 0/3] pktbuff API updates
Message-ID: <20200429195414.GC3833@dimstar.local.net>
Mail-Followup-To: Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20200426132356.8346-1-pablo@netfilter.org>
 <20200427110614.GA15436@dimstar.local.net>
 <20200427170656.GA22296@salvia>
 <20200428043302.GB15436@dimstar.local.net>
 <20200428103407.GA1160@salvia>
 <20200428211452.GF15436@dimstar.local.net>
 <20200428225520.GA30421@salvia>
 <20200429132840.GA3833@dimstar.local.net>
 <20200429190020.GA16096@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429190020.GA16096@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=RSmzAf-M6YYA:10
        a=3hXQTgT0DALnAf7DM8QA:9 a=JmEJIw0BOmCsy-di:21 a=iTuLv9zXbIsyl9dn:21
        a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 29, 2020 at 09:00:20PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Apr 29, 2020 at 11:28:40PM +1000, Duncan Roe wrote:
> > On Wed, Apr 29, 2020 at 12:55:20AM +0200, Pablo Neira Ayuso wrote:
> > > On Wed, Apr 29, 2020 at 07:14:52AM +1000, Duncan Roe wrote:
> > > > On Tue, Apr 28, 2020 at 12:34:07PM +0200, Pablo Neira Ayuso wrote:
> > > [...]
> > > > > pktb_alloc2() still has a memcpy which is not needed by people that do
> > > > > not need to mangle the packet.
> > > >
> > > > No it does not. Please look again. There is only a memcpy if the caller
> > > > specifies extra > 0, in which case she clearly intends to mangle it (perhaps
> > > > depending on its contents).
> > >
> > > Right, it only happens if extra is specified.
> > >
> > > +       if (extra) {
> > > +               pkt_data = buf;
> > > +               memcpy(pkt_data, data, len);
> > > +               memset((uint8_t *)pkt_data + len, 0, extra);
> > > +       } else {
> > > +               pkt_data = data;
> > > +       }
> > >
> > > So buf is only used if extra is specified?
> >
> > Yes, that's right.
>
> OK. Then, the user must pass the buf only if extra is set on.
>
> > > > Yes it's more complex. No problem with the buffer - the user gave that to
> > > > pktb_alloc2().
> > >
> > > I'm just hesitating about the new pktb_alloc2() approach because it
> > > has many parameters, it's just looks a bit complicated to me (this
> > > function takes 8 parameters).
> >
> > It has the original 4 from pktb_alloc() plus 2 {buffer, size} pairs. It could
> > have been just one pair, with packet data appended to metadata as in
> > pktb_alloc() but I thought it would be really awkward to document how to
> > dimension it.
>
> I'm starting to think this function is hard to document, too many
> parameters.

The documentation looks fine to me - I'm looking at it in a web browser right
now. Have you tried that?
>
> > I think we should not be usurping the data pointer of mnl_cb_run().
> > I can see people wanting to use it to pass a pointer to e.g. some
> > kind of database that callbacks need to access. There's no
> > performance gain to recycling the buffer: the CB doesn't need to
> > call pktb_head_size() on every invocation, that can be done once by
> > main() e.g.
> >
> >  static size_t sizeof_head;
> >  ...
> >  int main(int argc, char *argv[])
> >  {
> >  ...
> >          sizeof_head = pktb_head_size(); /* Avoid multiple calls in CB */
> >  ...
> >  static int queue_cb(const struct nlmsghdr *nlh, void *data)
> >  {
> >          char head[sizeof_head];
>
> You might also declare the pre-allocated pkt_buff as a global if you
> don't want to use the data pointer in mnl_cb_run().

I'm uneasy about this. We're writing a library here. We shouldn't be dictating
to the user that he must declare globals. "static" won't do in a multi-threaded
program, but you could use "thread local" (malloc'd under the covers, (tiny)
performance hit c/w stack (which is always thread local)).

"The road to bloat is paved with tiny performance hits" [1]

>
> static struct pkt_buff *pkt;
>
> int main(int argc, char *argv[])
> {
>         ...
>         pkt = pktb_head_alloc();
>         ...
> }
>
> Then, use it from queue_cb().
>
> Alternatively, you can also define a wrapper structure that you can
> pass to mnl_cb_run(), e.g.
>
> struct my_data {
>         struct pkt_buff *pktb;
>         void            *something_ese;
> };
>
> > > My understanding is that requirements are:
> > >
> > > * Users that do not want to mangle the packet, they use the buffer
> > >   that was passed to recvmsg().
> > > * Users that want to mangle the packet, they use the _mangle()
> > >   function that might reallocate the data buffer (the one you would
> > >   like to have). However, if this data buffer reallocation happens,
> > >   then pkt_buff should annotate that this pkt_buff object needs to
> > >   release this data buffer from pktb_free() otherwise.
> >
> > No, there is nothing to release. We told pktb_alloc2() where the buffer was,
> > it's on the stack (usually).
>
> Then, I'm not sure I understand yet what extension you would like to
> make to _mangle(), please, clarify.
>
> > > > Problem is that if mangler moves the packet, then any packet pointer the caller
> > > > had is invalid (points to the un-mangled copy). This applies at all levels, e.g.
> > > > nfq_udp_get_payload(). There is no way for the mangler functions to address
> > > > this: it just has to be highlighted in the documentation.
> > >
> > > That's fine, this is exactly how the kernel works: if the function
> > > might reallocate the data area, then you have to refetch pointers
> > > after this. If you teach _mangle() to do reallocations, then
> > > documenting this is fine.
> > >
> > > However, those reallocation need pktb_free() to release that new data
> > > buffer, right?
> >
> > No way. There is no malloc() nor free() anywhere. The data buffer is
> > (recommended to be) on the stack; for running under gdb it may be preferred to
> > us a static buffer which has to be dimensioned hugely.
>
> If the user pre-allocates the heap or place it in the stack is
> irrelevant, the save for the user is the memcpy() if it's only
> inspecting the packet (no mangling) and the out-of-line pkt_buff
> allocation / or place in the stack.
>
> If pktb_build_data() takes the extra parameter, I think the
> showstopper you mentioned is gone. Otherwise, please tell me what you
> cannot achieve with my patchset.

My patchset comes with documentation and yours does not. I am not volunteering
to document yours.

Would you like me to post a detailed review of your patchset? It will not be
pretty.
>
> Thanks.

[1] I just amde that up. Good eh?

Cheers ... Duncan.
