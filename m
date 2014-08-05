From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables null pointer
Date: Tue, 5 Aug 2014 17:25:36 +0200
Message-ID: <20140805152536.GA3219@salvia>
References: <CAFnufp1157iUqOpax6Po-PZivC_7TQSeQqtmJnnpNLVm3hzH9w@mail.gmail.com>
 <20140805100141.GA3480@salvia>
 <CAFnufp3mVBFVfLOmb3QofpPDubCYgzmOUc4u4vGM6gXv+6Rezg@mail.gmail.com>
 <20140805133907.GA3782@salvia>
 <CAFnufp0Mjc6yXywRVRiU=kYZw=USSQr=VFfG1gyiPXB53ZMMiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Matteo Croce <technoboy85@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54772 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbaHEPZQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:25:16 -0400
Content-Disposition: inline
In-Reply-To: <CAFnufp0Mjc6yXywRVRiU=kYZw=USSQr=VFfG1gyiPXB53ZMMiQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 05, 2014 at 05:07:28PM +0200, Matteo Croce wrote:
> 2014-08-05 15:39 GMT+02:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> > Could you give a try to the following patch? Thanks.
> 
> yes it works, but the rules are appended every time, not overwritten,
> is it the intended behaviour?

Yes. You have to flush the table before nft -f, eg. nft flush table ip
nat, before you load your ruleset again.
