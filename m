From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [PATCH][RFC] Race in ip_conntrack_alter_reply
Date: Mon, 17 May 2004 11:04:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1084784652.1909.43.camel@nienna.balabit>
References: <20040516210616.GA20291@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20040516210616.GA20291@linuxace.com>
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

2004-05-16, v keltezéssel 23:06-kor Phil Oester ezt írta:
> I am still experiencing near daily deadlocks on a few heavily used
> firewalls here (on all kernels from ~2.4.2x - 2.6.6).
> 
> In searching for a solution, I noticed that back in September 2003,
> Rusty Russell pointed out the possibility of a race in ip_conntrack_alter_reply
> and offered the below patch.
> 
> The relevant threads are:
> 
> http://lists.netfilter.org/pipermail/netfilter-devel/2003-September/012368.html
> http://lists.netfilter.org/pipermail/netfilter-devel/2003-September/012388.html
> 
> And the patch is included below.

  Does it fix your problems? There were conversations on problems with
ip_nat_setup_info() stuck in endless loop, but I did not experience any
problems up to now. Could you provide some more info about your setup?

-- 
 Regards,
   Krisztian KOVACS
