From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Forgive me for a hardware related q
Date: Tue, 8 Sep 2009 12:37:56 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0909081231200.19645@obet.zrqbmnf.qr>
References: <56378e320909080224i666d3be9vb03befbcc8b41a18@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Richard Horton <arimus.uk@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38165 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234AbZIHKh4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Sep 2009 06:37:56 -0400
In-Reply-To: <56378e320909080224i666d3be9vb03befbcc8b41a18@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-09-08 11:24, Richard Horton wrote:

>Secondly, does anyone know of a linux based ADSL router suitable for
>use on a home network which meets the following needs:-

One with integrated ADSL modem I am not aware of, but if the modem is 
separate anyway, you can ask your local store for a "computer", because 
that would do the job. Or a "box pc". Or some true embedded device 
OpenWRT can run on. Whatever.

Note however, that these embedded devices often do not have enough disk 
space to contain the standard (i.e. prebuilt) installation of the *full* 
sets.

>1. Full iptables implementation which lets me create my own rule set
>rather than some limited subset from a web interface,
>2. Allows create of tc profiles to provide qos. Probably using RED,
>HTB,SFQ and PRIO/PFIFO queues, also will need iptables mangle to set
>the DSCP markings.

