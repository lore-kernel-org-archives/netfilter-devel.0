Return-Path: <SRS0=4AXv=6N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D81E1C83000
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Apr 2020 21:12:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD9EC206F0
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Apr 2020 21:12:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgD2VMj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Apr 2020 17:12:39 -0400
Received: from correo.us.es ([193.147.175.20]:53284 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726511AbgD2VMj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Apr 2020 17:12:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 788BF12BFE0
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 23:12:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 68260BAAB4
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 23:12:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5DA43BAAAF; Wed, 29 Apr 2020 23:12:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6229F5211E
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 23:12:35 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 Apr 2020 23:12:35 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4553842EF9E0
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 23:12:35 +0200 (CEST)
Date:   Wed, 29 Apr 2020 23:12:34 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue 0/3] pktbuff API updates
Message-ID: <20200429211234.GB14508@salvia>
References: <20200426132356.8346-1-pablo@netfilter.org>
 <20200427110614.GA15436@dimstar.local.net>
 <20200427170656.GA22296@salvia>
 <20200428043302.GB15436@dimstar.local.net>
 <20200428103407.GA1160@salvia>
 <20200428211452.GF15436@dimstar.local.net>
 <20200428225520.GA30421@salvia>
 <20200429132840.GA3833@dimstar.local.net>
 <20200429190020.GA16096@salvia>
 <20200429195414.GC3833@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429195414.GC3833@dimstar.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 30, 2020 at 05:54:14AM +1000, Duncan Roe wrote:
> On Wed, Apr 29, 2020 at 09:00:20PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Apr 29, 2020 at 11:28:40PM +1000, Duncan Roe wrote:
> > > On Wed, Apr 29, 2020 at 12:55:20AM +0200, Pablo Neira Ayuso wrote:
> > > > On Wed, Apr 29, 2020 at 07:14:52AM +1000, Duncan Roe wrote:
> > > > > On Tue, Apr 28, 2020 at 12:34:07PM +0200, Pablo Neira Ayuso wrote:
> > > > [...]
> > > I think we should not be usurping the data pointer of mnl_cb_run().
> > > I can see people wanting to use it to pass a pointer to e.g. some
> > > kind of database that callbacks need to access. There's no
> > > performance gain to recycling the buffer: the CB doesn't need to
> > > call pktb_head_size() on every invocation, that can be done once by
> > > main() e.g.
> > >
> > >  static size_t sizeof_head;
> > >  ...
> > >  int main(int argc, char *argv[])
> > >  {
> > >  ...
> > >          sizeof_head = pktb_head_size(); /* Avoid multiple calls in CB */
> > >  ...
> > >  static int queue_cb(const struct nlmsghdr *nlh, void *data)
> > >  {
> > >          char head[sizeof_head];
> >
> > You might also declare the pre-allocated pkt_buff as a global if you
> > don't want to use the data pointer in mnl_cb_run().
> 
> I'm uneasy about this. We're writing a library here. We shouldn't be dictating
> to the user that he must declare globals. "static" won't do in a multi-threaded
> program, but you could use "thread local" (malloc'd under the covers, (tiny)
> performance hit c/w stack (which is always thread local)).
> 
> "The road to bloat is paved with tiny performance hits" [1]

In nf_queue, the way to go is to set the _GSO flag on the client and
then set on NFT_QUEUE_FLAG_CPU_FANOUT from the nft queue rule. If you
need multiple processes, then users pre-allocate one pkt_buff per
process.
