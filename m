From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [PATCH][RFC] Race in ip_conntrack_alter_reply
Date: Tue, 18 May 2004 17:12:54 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1084893174.1804.37.camel@nienna.balabit>
References: <20040516210616.GA20291@linuxace.com>
	 <1084784652.1909.43.camel@nienna.balabit>
	 <20040518144836.GA25729@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20040518144836.GA25729@linuxace.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

2004-05-18, k keltezéssel 16:48-kor Phil Oester ezt írta:
> I have not tried the patch yet -- I wanted to see if anyone else thought it
> looked sane.

  I second that it is sane, but of course my opinion isn't worth a bean.
I've already found that mail in the archives before, while searching for
NAT deadlock problems. 

> Not much unique about my situation -- box with 6 interfaces, one of which is
> internet link.  Pushing about 50mb peak per day...though the box dies at 2 - 6am
> when traffic is light.  Doing nat for a handful of subnets, but most of the
> /16 is not natted.  The box does run OSPF and has ~800 routes in the routing
> table.  What specific info were you looking for?

  Nothing specific. I just wanted to know if you're using
SNAT/DNAT/REDIRECT, and a rough description of the setup.

-- 
 Regards,
   Krisztian KOVACS
