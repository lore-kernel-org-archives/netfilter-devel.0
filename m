From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] fix nf_conntrack_netlink expectation dumping/event
 notification
Date: Fri, 13 Jan 2006 18:02:40 +0900 (JST)
Message-ID: <200601130902.k0D92feI006457@toshiba.co.jp>
References: <43C70536.7000608@netfilter.org>
	<43C76BA7.9080204@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp,
	pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <43C76BA7.9080204@trash.net>
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


Hi,

From: Patrick McHardy <kaber@trash.net>
Date: Fri, 13 Jan 2006 09:58:15 +0100

> Pablo Neira Ayuso wrote:
> > Hi Yasuyuki,
> > 
> > Currently we get an oops with nf_conntrack_netlink + nf_conntrack_ftp
> > because l3num is set to 0xFFFF for the expectation mask. At first sight,
> > this is correct because l3num is u_int16_t, but the size of the layer-3
> > array of protocol handlers is AF_MAX (32).
> > 
> > I could add some checking to verify that l3num is less than 32 in
> > nf_conntrack_find_l3proto, but such checking is only required for
> > nf_conntrack_ftp and further application helpers. AFAICS, this is the
> > cleanest way to fix this problem. Any other suggestion?
> 
> What is the exact cause for the crash? I looked over the code, but
> couldn't spot it.

I think that root caurse is missing check at __nf_ct_{l3}proto_find().
I'll write patch for it. It will free people from taking care about
expectation mask.

Regareds,

-- Yasuyuki Kozakai
