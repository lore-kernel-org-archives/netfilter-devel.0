From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables-xml
Date: Sun, 15 Nov 2009 16:07:11 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911151606110.24638@obet.zrqbmnf.qr>
References: <20091113144219.09c8c2a3@hobbes.loria.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Frederic Beck <frederic.beck@loria.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48485 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbZKOPHH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Nov 2009 10:07:07 -0500
In-Reply-To: <20091113144219.09c8c2a3@hobbes.loria.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2009-11-13 14:42, Frederic Beck wrote:
>
>I'm thinking about writing a configuration tool for iptables/ip6tables
>that would generate the rules according to a definition of services
>running on a network and other parameters.
>
>i saw that within netfilter there is already an XML format used by
>iptables-xml that can be converted back to the rules via an XSLT form.
>
>I was thinking of using that same XML representation (we are planning
>to use Netconf to configure remotely the devices), but i couldn't find
>it anywhere.
>
>Where can i get it ?

There is neither a DTD nor XSLT defined. Currently most projects just 
generate the rules directly, since that is easier than parsing them.
