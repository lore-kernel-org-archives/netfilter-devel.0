From: Patrick McHardy <kaber@trash.net>
Subject: Re: arptables - bulk/fast insert
Date: Tue, 06 Apr 2010 16:18:20 +0200
Message-ID: <4BBB42AC.7030503@trash.net>
References: <1270557553.2712.24.camel@qed>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Peter Gordon <peter@pg-consultants.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58781 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab0DFOSZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Apr 2010 10:18:25 -0400
In-Reply-To: <1270557553.2712.24.camel@qed>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Peter Gordon wrote:
> Is there a fast way to add rules to arptables, like ebtables-restore or
> iptables-restore?
> 
> arptables-restore is a perl script which runs arptables for each insert,
> so
> a) it is not atomic
> b) it is slow

Its certainly possible to write an atomic arptables-restore program,
but so far nobody has done it.
