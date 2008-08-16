From: =?UTF-8?B?UMSTdGVyaXMgS8S8YXZpxYbFoQ==?= <klavins@netspace.net.au>
Subject: Re: [RFC] netfilter: Rename ipt_ECN.h to ipt_ecn_target.h (and  
 similar) to avoid file name clash
Date: Sat, 16 Aug 2008 17:32:18 +0200
Message-ID: <g86rul$1gb$1@ger.gmane.org>
References: <g84ufs$l66$1@ger.gmane.org> <alpine.LNX.1.10.0808160958570.30044@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:33294 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbYHPPcz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Aug 2008 11:32:55 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KUNlo-0005yY-UO
	for netfilter-devel@vger.kernel.org; Sat, 16 Aug 2008 15:32:48 +0000
Received: from 217-133-15-180.b2b.tiscali.it ([217.133.15.180])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Aug 2008 15:32:48 +0000
Received: from klavins by 217-133-15-180.b2b.tiscali.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Aug 2008 15:32:48 +0000
In-Reply-To: <alpine.LNX.1.10.0808160958570.30044@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
>> include/linux/netfilter/xt_CONNMARK.h => xt_connmark_target.h
> [...]
> 
> As I see it, this will already be addressed by merging complementary
> code into one source file (e.g. MARK, mark, CONNMARK, connmark
> all into a big new xt_mark.c), to reduce (a) amount of files
> and (b) build time.
> 
> This has been touched before at
> http://marc.info/?l=netfilter-devel&m=121148631320895&w=2
> I welcome that idea, but have yet been holding off sending patches
> on that because these code-moving changes would possibly generate
> a lot of .rej noise while I am still having other patches in my
> queue.

Thanks very much for the heads-up on the pending code simplification, of 
course it makes sense to rename files as part of that work.

I'll clone git://git.netfilter.org/iptables.git regularly, watching for 
the file name clashes to go away, and I'll only nag on this list if I 
think that it's been forgotten, I hope that's OK.

-- 
  Peter Klavins

