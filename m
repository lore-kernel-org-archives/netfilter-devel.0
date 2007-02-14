From: Patrick McHardy <kaber@trash.net>
Subject: Re: Change Packet Payload
Date: Wed, 14 Feb 2007 10:52:59 +0100
Message-ID: <45D2DBFB.7040702@trash.net>
References: <1171012218.4162.27.camel@LinuxCampo>	<1171013512.18531.5.camel@localhost>	<45D23748.2090609@netfilter.org>
	<45D2DA9E.4010005@wengo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Sebastien Tricaud <sebastien.tricaud@wengo.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45D2DA9E.4010005@wengo.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Sebastien Tricaud wrote:

> Index: src/protocol_any_helper.c
> ===================================================================
> --- src/protocol_any_helper.c	(revision 0)
> +++ src/protocol_any_helper.c	(revision 0)
> @@ -0,0 +1,53 @@
> +/* 
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 
> + *  as published by the Free Software Foundation
> + */


> +/* (c) Richard W. Stevens */
> +unsigned short nfq_compute_cksum(unsigned short *data, int len)

Do you have permission to put this under the GPL?
