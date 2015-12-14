From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4] libmnl: Drop the EXPORT_SYMBOL() tags
Date: Mon, 14 Dec 2015 13:37:31 +0100
Message-ID: <20151214123731.GA26186@salvia>
References: <20151029190717.GE5154@vapier.lan>
 <CAMQP0snn7nt=iK6Um4doYFPSn1ffTDtUOKi8NBjp=ZCE58EXQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 20151006012711.GA5372@oxygen.gentoo.org,
	netfilter-devel@vger.kernel.org,
	Mike Frysinger <vapier@gentoo.org>,
	Caroline Tice <cmtice@google.com>
To: Neutron Soutmun <neo.neutron@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44543 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbbLNMhg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Dec 2015 07:37:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 58DD3B6BB4
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 13:37:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4FE9DDA807
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 13:37:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3970ADA878
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 13:37:32 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAMQP0snn7nt=iK6Um4doYFPSn1ffTDtUOKi8NBjp=ZCE58EXQw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cc'ing everyone that has sent patches to us to address libmnl
compilation problems with clang.

On Sat, Nov 14, 2015 at 07:45:44AM +0700, Neutron Soutmun wrote:
> The initial problem for my proposed patch is the incompatible of
> symbols visibility in gcc and clang
> which libmnl is failed to build from source in clang and it's the one
> of another approaches that pass the build in both gcc and clang.
> 
> I'll test your patch with clang and back to you ASAP.

Did anyone consider going back to the clang community and ask why
EXPORT_SYMBOL() definition is not correct there?

I understand removing this from our libraries is a quick solution, but
I think it would be to get feedback from them to see if it's something
that they can fix there (it would resolve problems for projects a using
similar definition without updating the code).

Let me know, thanks.
