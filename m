From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [PATCH] netfilter: xt_hashlimit: handle iptables-restore of hash
 with same name
Date: Fri, 15 Aug 2014 09:24:43 +0200
Message-ID: <20140815072443.GT3549@imap.eitzenberger.org>
References: <1406004850-31336-1-git-send-email-johunt@akamai.com>
 <20140724084927.GB18404@breakpoint.cc>
 <ffaf5ee3-2af6-4747-bdd1-481ed87e68aa@email.android.com>
 <53D28C97.9000009@akamai.com>
 <20140814140956.GA16567@imap.eitzenberger.org>
 <alpine.LSU.2.11.1408150545340.8983@nerf08.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josh Hunt <johunt@akamai.com>, Patrick McHardy <kaber@trash.net>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>,
	Harald Welte <laforge@netfilter.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:54990 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaHOHYs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2014 03:24:48 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1408150545340.8983@nerf08.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> >For case 2) the behaviour is unexpected: when using iptables-restore
> >to update an already existing hashtable <NAME> the updates are
> >ignored.
> 
> Well, in a way, this is expected. If ruletable A references hashtable
> G and you restore ruletable B also referencing G, you don't
> necessarily want to clear out G.

I agree when having multiple rules accessing same hashtable.  But on
rule update it is a bug.

I am fine maintaining the patch adressing the rule update, as I am
aware of the change in behaviour for the other case.

 /Holger

