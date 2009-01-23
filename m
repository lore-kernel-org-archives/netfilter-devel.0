From: NICOLAS BOULIANE <nicboul@gmail.com>
Subject: Re: Patch for geoip match agains kernel 2.6.28
Date: Thu, 22 Jan 2009 21:22:00 -0500
Message-ID: <dd45289d0901221822v2d52b653h3f961dd8b4563843@mail.gmail.com>
References: <000301c97cd4$4b810f30$e2832d90$%olav@bjerkeset.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Svein Olav Bjerkeset <svein.olav@bjerkeset.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:14591 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293AbZAWCWF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Jan 2009 21:22:05 -0500
Received: by wf-out-1314.google.com with SMTP id 27so5290503wfd.4
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Jan 2009 18:22:00 -0800 (PST)
In-Reply-To: <000301c97cd4$4b810f30$e2832d90$%olav@bjerkeset.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Svein,

Thanks for this patch. I'll update my patchlet repository as soon as I get home.

peace,
acidfu.

On Thu, Jan 22, 2009 at 3:59 PM, Svein Olav Bjerkeset
<svein.olav@bjerkeset.com> wrote:
> Hi,
>
> Changes in "struct xt_match" from kernel 2.6.27 to 2.6.28 made the latest
> version og Geoip match (Feb 11th 2008) from kernel version 2.6.28 on. I have
> developed a patch that will make Geoip match work with 2.6.28.
>
> The patch can be downloaded from the following URL:
> http://bjerkeset.com/patches/geoip-match-2.6.28.patch.gz
>
> The patch is against
> http://people.netfilter.org/acidfu/patchlets/geoip.tar.gz as of Feb 11th
> 2008.
>
> Regards,
> Svein Olav Bjerkeset
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
