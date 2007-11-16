From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnetfilter_conntrack broken on PPC
Date: Fri, 16 Nov 2007 13:30:15 +0100
Message-ID: <473D8D57.1000309@netfilter.org>
References: <200711161139.19580.victor.stinner@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Victor Stinner <victor.stinner@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46016 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763715AbXKPMam (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2007 07:30:42 -0500
In-Reply-To: <200711161139.19580.victor.stinner@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Victor Stinner wrote:
> Libnetfilter_conntrack doesn't work on PPC because a small bug in "getters" 
> (8, 16, 32 bits). The problem only occurs on big endian architecture and is 
> already fixed in subversion. My patch only fix big endian bug, and is very 
> small ;-)
> 
> I sent the patch to Pablo Neira Ayuso the first october, but he looks very 
> busy. Can someone else release a new version of libnetfilter_conntrack? If 
> nobody cares, can I get the status of new libnetfilter_conntrack maintainer?

I'll do it along today.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
