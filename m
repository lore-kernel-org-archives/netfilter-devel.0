From: Saatvik Agarwal <saatvik.agarwal@stanford.edu>
Subject: Re: [PATCH] TCP simultaneous open support
Date: Sun, 31 May 2009 17:50:09 -0700
Message-ID: <4ddb24250905311750q33f6193fi12dda710d75b2b28@mail.gmail.com>
References: <alpine.DEB.2.00.0905311614330.760@blackhole.kfki.hu>
	 <alpine.DEB.2.00.0905311631480.760@blackhole.kfki.hu>
	 <4ddb24250905311604o8d0f2c2l9ba3984ae296a009@mail.gmail.com>
	 <alpine.LSU.2.00.0906010149510.12927@fbirervta.pbzchgretzou.qr>
Reply-To: saatvik.agarwal@stanford.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:15698 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbZFAAuH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 31 May 2009 20:50:07 -0400
Received: by yx-out-2324.google.com with SMTP id 3so4026344yxj.1
        for <netfilter-devel@vger.kernel.org>; Sun, 31 May 2009 17:50:09 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0906010149510.12927@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hmm. I tried both the latest RC and the latest stable release. Same
problem. For example, the arrays in chunk 2 & 3 of nf_conntrack_tcp.h
are significantly longer in the latest release than indicated in the
diff. Am I missing something?

Thanks,
Saatvik

On 5/31/09, Jan Engelhardt <jengelh@medozas.de> wrote:
>
>  On Monday 2009-06-01 01:04, Saatvik Agarwal wrote:
>
>  >Hi Jozsef,
>  >
>  >Thanks a lot for the patch. What version of the kernel/netfilter code
>  >is this patch intended for? I'm running debian 2.6.26 (lenny) and I
>  >can't patch my source. 14 out of the 15 hunks fail.
>
>
> Often enough, whatever is cooking in Linus's (i.e. 2.6.30-rc currently).
>
