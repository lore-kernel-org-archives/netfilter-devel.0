From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftables] meta: Let user specify any combination of
 sreg/dreg
Date: Wed, 15 Jan 2014 11:35:16 +0100
Message-ID: <20140115103516.GA9911@localhost>
References: <1389445397-26132-1-git-send-email-kristian.evensen@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55376 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbaAOKfV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:35:21 -0500
Content-Disposition: inline
In-Reply-To: <1389445397-26132-1-git-send-email-kristian.evensen@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 11, 2014 at 02:03:17PM +0100, Kristian Evensen wrote:
> From: Kristian Evensen <kristian.evensen@gmail.com>
> 
> libnftables should not mask kernel errors. Let user specify any combination of
> parameters and leave the error-checking to the kernel. The kernel will return
> -EINVAL and users will know that they have to fix their code. This patch also a
> removes a redundant variable that was passed to the snprintf-functions (flag).
> 
> A second iteration might be needed. I was not sure how to deal with
> snprintf_default in the case of both sreg and dreg.

Applied, thanks Kristian.
