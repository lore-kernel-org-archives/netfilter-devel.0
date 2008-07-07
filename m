From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: TCP connection stalls under 2.6.24.7
Date: Mon, 7 Jul 2008 11:18:32 +0200
Message-ID: <200807071118.32988.thomas.jarosch@intra2net.com>
References: <47EA0DAB.7080205@securenet.de> <200807041654.15591.thomas.jarosch@intra2net.com> <Pine.LNX.4.64.0807042251500.4142@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Patrick McHardy <kaber@trash.net>,
	Sven Riedel <sr@securenet.de>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re01.intra2net.com ([82.165.28.202]:33295 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbYGGJSj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 05:18:39 -0400
In-Reply-To: <Pine.LNX.4.64.0807042251500.4142@blackhole.kfki.hu>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Jozsef,

On Friday, 4. July 2008 22:58:06 Jozsef Kadlecsik wrote:
> Have you got SACK enabled? If yes, try to disable it: TCP connection
> tracking has got some trouble with SACK support. :-(

Thanks for the suggestion. I disabled it but it made no difference.

> You have got a netfilter logging module loaded in, don't you? If yes and
> nf_conntrack_log_invalid produces no output, then I'd say it's not a
> netfilter related problem.

Yes, we log local REJECTs to aid debugging if something is blocked.

I'll upgrade to 2.6.25.10 and see if it helps,
there is a TCP connection timeout fix in there: 
http://kerneltrap.org/mailarchive/linux-kernel/2008/6/14/2122714

Thomas
