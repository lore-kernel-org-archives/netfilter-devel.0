From: Anton <anton.vazir@gmail.com>
Subject: Re: NFLOG - missing packets?
Date: Sat, 10 May 2008 17:50:37 +0500
Message-ID: <200805101750.38472.anton.vazir@gmail.com>
References: <200805101657.45111.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@inl.fr>, Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:55553 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669AbYEJMug (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 May 2008 08:50:36 -0400
In-Reply-To: <200805101657.45111.anton.vazir@gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Something wrong quite definitelly,
in 700Mb of the data it logs only 43Mb 

(btw in prev email it was 700 kilobytes, not megabytes)

On Saturday 10 May 2008 16:57, Anton wrote:
> Hello!
>
> Just did several test on the ULOGD2 - via NFLOG, and
> confused about the amount of data logged to the database.
>
> In the tests - I'm transferring 700Mb of data file, but
> sum of the field in DB (ulog2.ip_totlen) for transferred
> amount is ~280M. At the same time iptables -nL -v for the
> correspondinf iptables NFLOG enties - shows correct
> amount of matches - ~700Mb
>
> Tryed to set --nflog-range 100 or 200 (100 should be is
> more than enough though) - with no luck.
>
> Kernel - 2.6.24
> iptables v 1.4.0
> ulogd2 SVN - rev 7519 (checked today)
> DB - Postgresql 8.3.0
>
> ulogd - logs no errors
> dmesg logs no errors
> db logs no errors
>
> Am I missing something or ULOGD2 do not insert all of the
> packets into the DB (so this should be bug?) ?
>
> Regards,
> Anton.
>
> --
> To unsubscribe from this list: send the line "unsubscribe
> netfilter-devel" in the body of a message to
> majordomo@vger.kernel.org More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
