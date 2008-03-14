From: "Nishit Shah" <nishit@elitecore.com>
Subject: RE: Do nfnl_query and nfnl_catch are blocking fuctions ?
Date: Fri, 14 Mar 2008 11:47:24 +0530
Message-ID: <002901c8859b$11fa98c0$35efca40$@com>
References: <000e01c88502$8f4212c0$adc63840$@com> <47D957FC.3000900@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhost.elitecore.com ([203.88.135.194]:58685 "EHLO
	elitecore.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750783AbYCNGQt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Mar 2008 02:16:49 -0400
Received: from nishitshah.elitecore.co.in (HELO elitecore3) ([192.168.1.76])
          (envelope-sender <nishit@elitecore.com>)
          by elitecore.com (qmail-ldap-1.03) with SMTP
          for <netfilter-devel@vger.kernel.org>; 14 Mar 2008 05:52:59 -0000
In-Reply-To: <47D957FC.3000900@netfilter.org>
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yes,
	I am using libnetfilter_conntrack for adding expected connection
through Application Proxies. Now, sometimes my proxy hangs and when I do gdb
on the core generated, recvmsg call is in waiting mode.

	I have changed libnetfilter_conntrack slightly to make it single
socket for my Proxy. I do nfct_open at time of proxy start, do
nfct_create_expectation every time request comes and nfct_close when proxy
ends.

Rgds,
Nishit Shah.    

-----Original Message-----
From: netfilter-devel-owner@vger.kernel.org
[mailto:netfilter-devel-owner@vger.kernel.org] On Behalf Of Pablo Neira
Ayuso
Sent: Thursday, March 13, 2008 10:06 PM
To: Nishit Shah
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Do nfnl_query and nfnl_catch are blocking fuctions ?

Nishit Shah wrote:
> Hi,
>                 Is it possible that on high rate of conntrack
> addition/deletion/updation, nfnl_query or nfnl_catch, If space is not
> available at the sending socket these fuctions will block as they are
using
> sendto and recvmsg calls ?

What kind of behaviour are you observing? Please elaborate.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
--
To unsubscribe from this list: send the line "unsubscribe netfilter-devel"
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

