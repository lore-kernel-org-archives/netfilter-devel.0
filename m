From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: updated ctnetlink
Date: 22 May 2003 15:31:20 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1053610279.15180.64.camel@tux.rsn.bth.se>
References: <20030522124450.GA30151@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Balazs Scheidler <bazsi@balabit.hu>
In-Reply-To: <20030522124450.GA30151@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2003-05-22 at 14:44, Balazs Scheidler wrote:
> Hi,
> 
> while trying to resolve issues with TPROXY I came to the conclusion that I
> might need ctnetlink, but the version in pom seems to be outdated. Is there
> a more current version? And provided there is none, shall I put resources
> into updating it to the latest kernels?

The version in p-o-m is working fine here on 2.4.21-rc1
(with a few fixes so userspace can't crash the kernel so easily
http://kashyyyk.netfilter.org/~gandalf/patches/nfnetlink_conntrack-fix.diff
one hunk of it has been integrated into p-o-m)

-- 
/Martin
