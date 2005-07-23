From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?=
	<yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH] 1 Wire drivers illegally overload NETLINK_NFLOG
Date: Fri, 22 Jul 2005 23:15:26 -0400 (EDT)
Message-ID: <20050722.231526.131178865.yoshfuji@linux-ipv6.org>
References: <20050723125427.GA11177@rama>
	<20050722.230559.123762041.yoshfuji@linux-ipv6.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Cc: johnpol@2ka.mipt.ru, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20050722.230559.123762041.yoshfuji@linux-ipv6.org>
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

In article <20050722.230559.123762041.yoshfuji@linux-ipv6.org> (at Fri, 22 Jul 2005 23:05:59 -0400 (EDT)), YOSHIFUJI Hideaki / 吉藤英明 <yoshfuji@linux-ipv6.org> says:

> In article <20050723125427.GA11177@rama> (at Sat, 23 Jul 2005 08:54:27 -0400), Harald Welte <laforge@netfilter.org> says:
> 
> > --- a/include/linux/netlink.h
> > +++ b/include/linux/netlink.h
> > @@ -20,7 +20,7 @@
> >  #define NETLINK_IP6_FW		13
> >  #define NETLINK_DNRTMSG		14	/* DECnet routing messages */
> >  #define NETLINK_KOBJECT_UEVENT	15	/* Kernel messages to userspace */
> > -#define NETLINK_TAPBASE		16	/* 16 to 31 are ethertap */
> > +#define NETLINK_W1		16	/* 16 to 31 are ethertap */
> >  
> >  #define MAX_LINKS 32		
> >  
> 
> Comment says that 16-31 are used for ethertap.
> So, probably assigh NETLINK_W1 at 32, and bump MAX_LINKS?

I should say "were"; ethertap was removed.
But I still don't think we should reuse it.

--yoshfuji
