From: Jeremy Kerr <jeremy@redfishsoftware.com.au>
Subject: Re: [ANNOUNCE] nfsim - netfilter simulation environment
Date: Thu, 8 Jan 2004 08:41:01 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401080841.02152.jeremy@redfishsoftware.com.au>
References: <20040107192530.99189.qmail@web60701.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Zeeshan Ali <zeelists@yahoo.com>, netfilter-devel@lists.netfilter.org
In-Reply-To: <20040107192530.99189.qmail@web60701.mail.yahoo.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


> core/netfilter.c:453: conflicting types for
> `nf_hook_slow'

Looks like you're importing netfilter modules from 2.4 source. I've made a few 
changes that are in today's snapshot which should solve most of the problems 
here...

> core/netfilter.c:581: warning: implicit declaration of
> function `ip_dev_find'

... except for this one. Which version of the kernel are you importing from?

Try the 20040108 snapshot and/or importing from a 2.6 source tree. I'll take a 
look at the ip_dev_find problem in the meantime.


Jeremy
