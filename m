From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 1/3] tests: fix error reporting
Date: Tue, 1 Oct 2013 11:45:38 +0200
Message-ID: <20131001094538.GB7573@localhost>
References: <20130930150551.32124.23680.stgit@nfdev.cica.es>
 <20130930174157.GA31379@localhost>
 <CAOkSjBjFsqZSSaNr6jUMN3aZR=fA+TR2dBSVNyOp_xLGt84DvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:54284 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751477Ab3JAJpo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Oct 2013 05:45:44 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBjFsqZSSaNr6jUMN3aZR=fA+TR2dBSVNyOp_xLGt84DvQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 01, 2013 at 12:02:15AM +0200, Arturo Borrero Gonzalez wrote:
> On 30 September 2013 19:41, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Sep 30, 2013 at 05:05:52PM +0200, Arturo Borrero Gonzalez wrote:
> >> The testbench was not reporting errors properly.
> >>
> >> With this patch, "1" is returned to the shell if the test failed (instead of
> >> returning "0" unconditionally). Textual reporting is also fixed.
> >
> > How is it broken?
> >
> > IIRC the error reporting provides some rudimentary cursor to indicate
> > where the problem happens. I think this patch breaks it.
> 
> I don't see where the break happens. Could you give me some hints?
> 
> For me, the cursor works as expected.

This patch includes changes for different things, please split it in
chunks including the corresponding description. Thanks.
