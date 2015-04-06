From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2] parser: add kludges for "param-problem" and "redirect"
Date: Mon, 6 Apr 2015 13:23:51 +0200
Message-ID: <20150406112350.GA24191@acer.localdomain>
References: <551FC211.6000907@ahsoftware.de>
 <1428145986-15421-1-git-send-email-holler@ahsoftware.de>
 <20150404115550.GA5832@salvia>
 <20150405113214.GA23433@acer.localdomain>
 <20150405121104.GD23433@acer.localdomain>
 <CAOkSjBis1LsHZgU7A0R6g5vP_WfZ2Xj9UK3krgKotZ0DuRfE7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Alexander Holler <holler@ahsoftware.de>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>, Eric Leblond <eric@regit.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33711 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbbDFLXz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Apr 2015 07:23:55 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBis1LsHZgU7A0R6g5vP_WfZ2Xj9UK3krgKotZ0DuRfE7w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06.04, Arturo Borrero Gonzalez wrote:
> On 5 April 2015 at 14:11, Patrick McHardy <kaber@trash.net> wrote:
> >
> > This needs a lot of testing though since it has the potential to break
> > things quite badly. Since I'm busy, maybe someone else wants to start by
> > running the testsuite with this patch applied.
> 
> I was curious and ran the testsuite with your patch. It's OK.

Thanks Arturo!
