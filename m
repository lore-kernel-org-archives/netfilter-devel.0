From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: =?utf-8?B?562U5aSNOiDnrZTlpI06IFtQQVRD?=
 =?utf-8?Q?H=5D=3A_netfilter=3A_ftp=2Firc=2Fsane=2Fsip=2Ftftp=3A_Fix_th?=
 =?utf-8?Q?e?= kernel panic when load these modules with duplicated ports
Date: Wed, 21 Oct 2015 10:52:13 +0200
Message-ID: <20151021085213.GA1081@salvia>
References: <BAY403-EAS55DEFB461D662C9DA7662795420@phx.gbl>
 <BAY403-EAS49051FE98EBBE5A72C2E2695420@phx.gbl>
 <20150925112028.GA7930@salvia>
 <BAY403-EAS322E3082C2EE709D656EAA095420@phx.gbl>
 <BAY403-EAS3176BC70926B09E2359072395380@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Feng Gao <gfree.wind@outlook.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35393 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705AbbJUIp0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Oct 2015 04:45:26 -0400
Content-Disposition: inline
In-Reply-To: <BAY403-EAS3176BC70926B09E2359072395380@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 21, 2015 at 08:21:12AM +0800, Feng Gao wrote:
> Hi Pablo,
> 
> How about this patch? It will be applied?

Could you investigate if it would be possible to add a
nf_conntrack_helpers_register()?

The idea is to have a native function that handles array of helpers.
We have something similar for _hooks.

Moreover, reduce the length of your patch subject to ~80 chars if
possible.

Thanks.
