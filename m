From: Wang Jian <lark@linux.net.cn>
Subject: Re: [PATCH 2/2] Port nfnetlink and nfnetlink_conntrack to 2.6
Date: Wed, 30 Mar 2005 23:57:29 +0800
Message-ID: <20050330235438.01A4.LARK@linux.net.cn>
References: <4247481F.9090702@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <4247481F.9090702@eurodev.net>
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

Hi Pablo Neira,

I want to use nfnetlink-ctnetlink to keep track of successful session in
a project. Can you make it avaible in pom-ng?

Thanks.

On Mon, 28 Mar 2005 01:56:15 +0200, Pablo Neira <pablo@eurodev.net> wrote:

> Comments about changes:
> 
> o Minor change: my compiler (gcc-2.95) complained about ct_debug so I 
> inserted the classical DEBUGP macro.
> 
> o No important modifications in nfnetlink.c
> 
> o Added support to identify conntracks by id.
> 
> o Removed ordered list, now we just insert a unsigned int in struct 
> ip_conntrack to hold the id. Now the table dumping is done iterating the 
> hash table.
> 
> o Adaptation to ct-event API
> 
> o improved way to delete a conntrack (marcus sundberg)
> 
> o kill [dump|change]_natinfo, now that must be handle in 
> [dump|change]_status.
> 
> o IMPORTANT: I haven't tested expectation handling.
> 
> Things I consider to do:
> 
> o split CTNL_MSG_GETCONNTRACK to two messages types: 
> CTNL_MSG_GETCONNTRACK and CTNL_MSG_DMPCONNTRACK (dump)
> 
> o split CTNL_MSG_NEWCONNTRACK to two messages types: 
> CTNL_MSG_NEWCONNTRACK and CTNL_MSG_UPDCONNTRACK (update)
> 
> o Move nfnetlink.h and nfnetlink_conntrack.h to netfilter/ directory.



-- 
  lark
