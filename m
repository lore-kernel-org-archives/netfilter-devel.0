From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] netfilter: xt_hashlimit: handle iptables-restore of hash
 with same name
Date: Fri, 15 Aug 2014 05:58:10 +0200 (CEST)
Message-ID: <alpine.LSU.2.11.1408150545340.8983@nerf08.vanv.qr>
References: <1406004850-31336-1-git-send-email-johunt@akamai.com> <20140724084927.GB18404@breakpoint.cc> <ffaf5ee3-2af6-4747-bdd1-481ed87e68aa@email.android.com> <53D28C97.9000009@akamai.com> <20140814140956.GA16567@imap.eitzenberger.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Josh Hunt <johunt@akamai.com>, Patrick McHardy <kaber@trash.net>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>,
	Harald Welte <laforge@netfilter.org>
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:49918 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbaHOD6O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Aug 2014 23:58:14 -0400
In-Reply-To: <20140814140956.GA16567@imap.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2014-08-14 16:09, Holger Eitzenberger wrote:
>
>For case 2) the behaviour is unexpected: when using iptables-restore
>to update an already existing hashtable <NAME> the updates are
>ignored.

Well, in a way, this is expected. If ruletable A references hashtable
G and you restore ruletable B also referencing G, you don't
necessarily want to clear out G.

The sensible fix is to have atomic replace of the entire ruleset
compassing all ruletables. Then, since all ruletables are going to
get replaced, replacing G with new parameters is also permissible.

At which point you may just question why the archaic concept of
separate ruletables was carried over to nf_tables;
compatibility for iptables to know which chain belongs to which table
is just another label on the object of a (modern) chain.
