From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: kernel 4.5.1 issue at system boot
Date: Mon, 23 May 2016 11:57:06 +0200
Message-ID: <20160523095706.GA2193@salvia>
References: <CAOkSjBh-P0RNKhNeR8fBmRVda7mtU9332punaUufO4Rx3aqpqA@mail.gmail.com>
 <CAOkSjBh--Ro9YzOdsTQsK6F73kPMdihjfU-tbyHc9gYN4gjOYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45686 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbcEWJ5U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2016 05:57:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A2CD7E8393
	for <netfilter-devel@vger.kernel.org>; Mon, 23 May 2016 11:57:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8D99611D026
	for <netfilter-devel@vger.kernel.org>; Mon, 23 May 2016 11:57:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DFE1415D646
	for <netfilter-devel@vger.kernel.org>; Mon, 23 May 2016 11:57:11 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAOkSjBh--Ro9YzOdsTQsK6F73kPMdihjfU-tbyHc9gYN4gjOYA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 23, 2016 at 08:50:29AM +0200, Arturo Borrero Gonzalez wrote:
> On 23 May 2016 at 08:49, Arturo Borrero Gonzalez
> <arturo.borrero.glez@gmail.com> wrote:
> > This was in the log of my system boot today:
> >
> 
> Probably more readable in this link:
> 
> http://paste.debian.net/695904/

Please, give a try to this one to confirm this resolves your issue:

http://patchwork.ozlabs.org/patch/622175/

Thanks.
