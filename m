From: Julian Anastasov <ja@ssi.bg>
Subject: Re: [PATCH 1/1] ip_vs_sip_fill_param() uninitialized var
Date: Thu, 25 Apr 2013 10:37:13 +0300 (EEST)
Message-ID: <alpine.LFD.2.00.1304251035540.1752@ja.ssi.bg>
References: <1366817341-23837-1-git-send-email-hans@schillstrom.com>  <alpine.LFD.2.00.1304242223290.1852@ja.ssi.bg> <1366870330.2628.172.camel@hawk.mlab.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Simon Horman <horms@verge.net.au>,
	Wensong Zhang <wensong@linux-vs.org>,
	lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Hans Schillstrom <hans@schillstrom.com>
Return-path: <lvs-devel-owner@vger.kernel.org>
In-Reply-To: <1366870330.2628.172.camel@hawk.mlab.se>
Sender: lvs-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


	Hello,

On Thu, 25 Apr 2013, Hans Schillstrom wrote:

> I'll send a new patch and I will also remove the unneeded check for zero
> matchlen since it is all ready done in ct_sip_get_header() 

	OK

> -	/* Empty callid is useless */
> -	if (!*matchlen)
> -		return -EINVAL;
> -
> 
> Thanks
> Hans

Regards

--
Julian Anastasov <ja@ssi.bg>
