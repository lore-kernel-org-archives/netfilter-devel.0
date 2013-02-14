From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] change XML output format to element better
 than attributes
Date: Thu, 14 Feb 2013 09:34:13 +0100
Message-ID: <20130214083413.GB3343@localhost>
References: <20130213221513.11611.54603.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:64097 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932311Ab3BNIeT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Feb 2013 03:34:19 -0500
Content-Disposition: inline
In-Reply-To: <20130213221513.11611.54603.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 13, 2013 at 11:15:13PM +0100, Arturo Borrero wrote:
> Some of the problems with attributes are:
> 
> * attributes cannot contain multiple values (child elements can)
> * attributes are not easily expandable (for future changes)
> * attributes cannot describe structures (child elements can)
> * attributes are more difficult to manipulate by program code
> * attribute values are not easy to test against a DTD
> 
> Examples of this question at: http://www.w3schools.com/dtd/dtd_el_vs_attr.asp

Applied, thanks.
