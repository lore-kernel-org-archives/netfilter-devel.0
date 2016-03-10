From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [RFC] net: ipv4 -- Introduce ifa limit per net
Date: Fri, 11 Mar 2016 01:40:56 +0300
Message-ID: <20160310224056.GF1989@uranus.lan>
References: <20160310.160521.1642655131932337300.davem@davemloft.net>
 <20160310211945.GD1989@uranus.lan>
 <20160310215959.GE1989@uranus.lan>
 <20160310.173630.525547775491939864.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xiyou.wangcong@gmail.com, alexei.starovoitov@gmail.com,
	eric.dumazet@gmail.com, netdev@vger.kernel.org, solar@openwall.com,
	vvs@virtuozzo.com, avagin@virtuozzo.com, xemul@virtuozzo.com,
	vdavydov@virtuozzo.com, khorenko@virtuozzo.com,
	pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160310.173630.525547775491939864.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Mar 10, 2016 at 05:36:30PM -0500, David Miller wrote:
> > 
> > Works like a charm! So David, what are the next steps then?
> > Mind to gather all your patches into one (maybe)?
> 
> I'll re-review all of the changes tomorrow and also look into ipv6
> masq, to see if it needs the same treatment, as well.
> 
> Thanks for all of your help and testing so far.

Thanks a lot, David!
