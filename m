From: Pablo Neira <pablo@eurodev.net>
Subject: Re: sparc64 match module - bug id 94
Date: Sun, 09 May 2004 16:30:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <409E408A.7060608@eurodev.net>
References: <20040505065402.GA18440@hamachi.radom.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20040505065402.GA18440@hamachi.radom.org>
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

I think that if we use the autoconf stuff in iptables (see "[PATCH] 
Autoconf stuff for iptables"), we can workaround this problem by 
defining a different ipt_limit.h header in the iptables tree, actually a 
not so different header, just the same ipt_limit.h file but it contains 
in this case:

#ifdef __sparc64__
    u_int64_t master;
#else
    struct ipt_rateinfo *master;
#endif

so we shouldn't need to modify anything in kernel. This way we can keep 
those ifdef's in user space to workaround problems with tricky 
architectures which have different types in kernel and user space. Well, 
it's not so clean but it's easy.

regards,
Pablo
