From: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Subject: Re: TCP connection stalls under 2.6.24.7
Date: Thu, 31 Jul 2008 11:11:42 -0300
Message-ID: <20080731111142.1931a960@tux>
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
Received: from py-out-1112.google.com ([64.233.166.179]:3277 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbYGaOLz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 10:11:55 -0400
Received: by py-out-1112.google.com with SMTP id p76so295924pyb.10
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Jul 2008 07:11:55 -0700 (PDT)
In-Reply-To: <200807311547.57189.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 31 Jul 2008 15:47:55 +0200
Thomas Jarosch <thomas.jarosch@intra2net.com> wrote:

> echo 0 > /proc/sys/net/ipv4/tcp_frto
	
	Ok, i'm testing here. If I have any conclusions I'll return.

> Nice, so Ilpo can "test" (=bombard) it with big messages ;-)

	ehehe no problem. As long as you post on u-br.teste, you can do
whatever tests you want ;) 

	But I'm not completely sure my problem is tcp_frto related,
since sometimes it just happened when I "sudo" some program... I'll
keep investigating it. Thanks.


-- 
