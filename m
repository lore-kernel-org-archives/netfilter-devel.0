From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] ct_sync 0.15 (corrected)
Date: Sun, 22 Aug 2004 02:40:28 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4127EB7C.60103@trash.net>
References: <1092407190.2402.120.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	jamal <hadi@cyberus.ca>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <1092407190.2402.120.camel@nienna.balabit>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Krisztian,

KOVACS Krisztian wrote:

>     4. The current version is 2.4-only, it is for the good old
>        ip_conntrack, and supports IPv4 only. I don't really think
>        this is the way to go, but there is commercial interest in
>        having this kind of failover functionality as fast as possible.
>        However, I think that after reaching some state which is
>        acceptable for the users needing the basic features fast, this
>        whole thing should be re-designed and ported to 2.6 and
>        nf_conntrack. This would depend on a few other things, such as
>        porting ctnetlink for nf_conntrack, but I thing those would
>        be important to have as well. Again, this would be quite a
>        lot work to do, thus deferring the 'stable' (production ready)
>        release of the code.
>

Are there any differences between the nfnetlink-ctnetlink patch and the
ctnetlink patch in the netfilter-ha repository ? Porting ctnetlink to
2.6 would be a start. Maybe someone wants to do it, otherwise I'll do
it on a rainy day ..

Regards
Patrick
