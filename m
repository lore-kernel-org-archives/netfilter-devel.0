From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack & valgrind
Date: Fri, 11 Jan 2008 02:27:34 +0100
Message-ID: <4786C606.3070802@netfilter.org>
References: <d95317090801080112v662f7fcdk36b582d14557896d@mail.gmail.com>	 <d95317090801091757s5ba5bcbfnf066f011e3488761@mail.gmail.com>	 <478611EC.1050205@netfilter.org> <d95317090801101221w5ac29c19i2e6e9d493dfa1114@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Gilad Benjamini <gilad.benjamini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49483 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756178AbYAKB1p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2008 20:27:45 -0500
In-Reply-To: <d95317090801101221w5ac29c19i2e6e9d493dfa1114@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Gilad Benjamini wrote:
> I am actually not sure what version combination I initially had. Some
> mix-n-match.
> I tried this on my Ubuntu, with the latest binary packages from
> apt-get, and got the same errors.

Could you please tell me the version of the conntrack-tools and
libraries to reproduce the problem?

> I then tried downloading latest release (having some local problem
> with snapshots)
> conntrack-tools-0.9.5.tar.bz2
> libnetfilter_conntrack-0.0.82.tar.bz2
> libnfnetlink-0.0.30.tar.bz2
> ... and conntrack failed to compile ;-(
> 
> At this point I gave up. I'll wait for the next releases and try again

Well... where does it stop compiling? Probably you're missing some
dependencies to compile the packages.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
