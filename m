From: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Subject: Re: TCP connection stalls under 2.6.24.7
Date: Wed, 6 Aug 2008 15:53:06 -0300
Message-ID: <20080806155306.72039010@tux>
References: <47EA0DAB.7080205@securenet.de>
	<200807310939.42406.thomas.jarosch@intra2net.com>
	<20080731094436.12ec99ae@tux>
	<200807311547.57189.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Cc: "Ilpo =?ISO-8859-1?Q?J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>,
	Netdev <netdev@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Sven Riedel <sr@securenet.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	David Miller <davem@davemloft.net>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:30498 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbYHFSxP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Aug 2008 14:53:15 -0400
Received: by yw-out-2324.google.com with SMTP id 9so36677ywe.1
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Aug 2008 11:53:14 -0700 (PDT)
In-Reply-To: <200807311547.57189.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 31 Jul 2008 15:47:55 +0200
Thomas Jarosch <thomas.jarosch@intra2net.com> wrote:

> If your problem is really FRTO related (that what the patch is for),
> you could try to disable FRTO temporarily:

	Hi, the patch helped, but what's the conclusion? Is the problem
"solved"? Will this patch be merged in the next kernel? This thread
seems to be forgotten.

	Thank you.
