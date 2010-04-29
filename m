From: David F <netfilter@meta-dynamic.com>
Subject: Re: nfnetlink_queue: which userspace library?
Date: Wed, 28 Apr 2010 23:21:25 -0400
Message-ID: <4BD8FB35.10307@meta-dynamic.com>
References: <4BD72377.8070400@meta-dynamic.com> <1272441583.29439.10.camel@khasse.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from troy.meta-dynamic.com ([204.11.35.233]:40113 "EHLO
	mail.meta-dynamic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab0D2DVb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Apr 2010 23:21:31 -0400
In-Reply-To: <1272441583.29439.10.camel@khasse.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> libnetfilter_queue is the official and most used library.
[...]
> http://www.nufw.org/doc/libnetfilter_queue/ is the most accurate
> libnetfilter_queue documentation.
> An example program is available in the source :
> http://git.netfilter.org/cgi-bin/gitweb.cgi?p=libnetfilter_queue.git;a=blob;f=utils/nfqnl_test.c
>
> Real life example can be found in :
>       * suricata:
>         http://www.openinfosecfoundation.org/index.php/download-suricata
>       * NuFW:
>         http://www.nufw.org/projects/nufw/repository/revisions/master/entry/src/nufw/packetsrv.c
>
> You can even use libnetfilter_queue with high-level langage:
> http://www.nufw.org/projects/nfqueue-bindings
>   

Thank you very much!  These are great resources.
-- David F.

