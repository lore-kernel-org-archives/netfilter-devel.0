From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libmnl: Failed to build with clang, incompatible
 EXPORT_SYMBOL(x) macro
Date: Thu, 1 Oct 2015 00:12:41 +0200
Message-ID: <20150930221241.GA14943@salvia>
References: <20150925040745.GA433@oxygen>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: Neutron Soutmun <neo.neutron@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42901 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbbI3WFz convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Sep 2015 18:05:55 -0400
Content-Disposition: inline
In-Reply-To: <20150925040745.GA433@oxygen>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 25, 2015 at 11:07:45AM +0700, Neutron Soutmun wrote:
> The EXPORT_SYMBOL(x) macro causes clang compile error and warning
> messges:
>   error,   "note: previous definition is here"
>   warning, "warning: attribute declaration must precede definition
>             [-Wignored-attributes]"
>   See: [1]
> 
> This proposed patch has been prepared to fix this error which make the
> EXPORT_SYMBOL macro define a precede definition of an attribute
> declaration. This approach is both compatible with gcc and clang.

We have more libraries using this approach, which resembles kernel
coding. So we would need to update them all, which is a bit annoying.

Though this warning results in a real problem since symbols will not
be exported.

Why is clang rejecting this?
