From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: Who currently owns ip_conntrack_sip?
Date: Wed, 13 Feb 2008 09:51:01 +0100
Message-ID: <200802130951.01515.thomas.jarosch@intra2net.com>
References: <47B279B9.4000202@redfish-solutions.com> <200802130925.05066.thomas.jarosch@intra2net.com> <47B2AB54.1020305@redfish-solutions.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Philip Prindeville <philipp@redfish-solutions.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs02.intra2net.com ([81.169.173.116]:1934 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727AbYBMJNM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:13:12 -0500
In-Reply-To: <47B2AB54.1020305@redfish-solutions.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Philip,

On Wednesday, 13. February 2008 09:33:24 you wrote:
> Ok.  I had a simple patch I'd like to see included that makes debugging
> output dependent on a load-time module parameter, i.e. "debug=1".

Oh, you got a patch, then netfilter-devel is the right place to go.
Just resend it to netfilter-devel. The source file of ip_conntrack_sip.c
got a MODULE_AUTHOR line, you could try CC: him, too:

MODULE_AUTHOR("Christian Hentschel <chentschel@arnet.com.ar>");

Regards,
Thomas
