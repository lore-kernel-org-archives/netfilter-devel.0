From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: nftables add vs replace
Date: Tue, 21 Jan 2014 13:46:24 +0200
Message-ID: <52DE5E10.5000403@linux.intel.com>
References: <20140121110645.GC25197@macbook.localnet> <20140121112700.GA21772@localhost> <CAOkSjBiKGk66N5Ecg8EM27osWVB1Zbn6r-rPu=o8DczjUjpKiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5125 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185AbaAULq1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 06:46:27 -0500
In-Reply-To: <CAOkSjBiKGk66N5Ecg8EM27osWVB1Zbn6r-rPu=o8DczjUjpKiA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

> Think about a 'ruleset.nft' file starting like this:
> ==== 8< ====
> wipe ruleset

That hits the current problem: you have to wipe-out all before creating 
stuff: it's greedy,
instead of just letting untouched/replace what exists already and adding 
new ones.

> table ip filter {
