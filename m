From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ebtables-compat-experimental5 PATCH] iptables: xtables-eb:
 user-defined chains default policy is always RETURN
Date: Thu, 20 Nov 2014 13:01:49 +0100
Message-ID: <20141120120149.GA9609@salvia>
References: <20141119131147.15524.18916.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, giuseppelng@gmail.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55345 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbaKTL7r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Nov 2014 06:59:47 -0500
Content-Disposition: inline
In-Reply-To: <20141119131147.15524.18916.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 19, 2014 at 02:11:47PM +0100, Arturo Borrero Gonzalez wrote:
> The RETURN default policy is mandatory in user-defined chains.
> Builtin chains must have one of ACCEPT or DROP.
> 
> So, with this patch, ebtables-compat ends with:
> 
> Command:			Result:
> 
> -L				Always RETURN for user-defined chains
> -P builtin RETURN		Policy RETURN only allowed for user defined chains
> -P builtin ACCEPT|DROP		ok
> -P userdefined RETURN		Default policy in user-defined chains is RETURN
> -P userdefined ACCEPT|DROP	Default policy in user-defined chains is RETURN
> -N userdefined			ok
> -N userdefined -P RETURN	Default policy in user-defined chains is RETURN
> -N userdefined -P ACCEPT|DROP	Default policy in user-defined chains is RETURN

Good that this looks smaller, applied thanks.
