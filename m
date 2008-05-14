From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: NFLOG - missing packets?
Date: Wed, 14 May 2008 19:49:26 +0200
Message-ID: <482B2626.8080902@netfilter.org>
References: <200805101657.45111.anton.vazir@gmail.com> <200805101750.38472.anton.vazir@gmail.com> <20080511161837.GJ11778@ice-age> <200805121224.12073.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-6
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
To: Anton <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52006 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760294AbYENRtb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 May 2008 13:49:31 -0400
In-Reply-To: <200805121224.12073.anton.vazir@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Anton wrote:
> Just some extra results,
> 
> seems DB drivers does such a difference, since while logging 
> to LOGEMU (only) target - I've go result which looks true. 
> But - If I enable DB logger - results in DB and LOGEMU - 
> are the same. Looks like DB transfers makes ULOG to not 
> accept packets from kernelspace

The problem is netlink that cannot back off. Netlink is the underlying
communication subsystem that we use to communicate kernel with usepace
space. Since Netlink is unreliable, some log messages can vanish under
heavy load. I guess that database insertions consumes lots of CPU
resouces. Thus, doing online database logging in a scalable manner turns
really hard. Instead, if you need scalability, I'd suggest to use logemu
or whatever plain text logging facility and then convert it to a
database *offline* if you really need advanced queries.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
