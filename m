From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libnetfilter_conntrack: add extern C's to public headers
Date: Fri, 30 Mar 2007 00:35:49 +0200
Message-ID: <460C3F45.4040406@netfilter.org>
References: <45FF7A38.8090907@ipom.com> <460C382E.6020108@netfilter.org>
	<20070329221220.GC15170@ipom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Phil Dibowitz <phil@ipom.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070329221220.GC15170@ipom.com>
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

Phil Dibowitz wrote:
> On Fri, Mar 30, 2007 at 12:05:34AM +0200, Pablo Neira Ayuso wrote:
>> Do you really need to include the extern "C" in linux_nfnetlink_conntrack.h?
> 
> I believe so, yes. The alternative is to put it around the #include of
> linux_nfnetlink_conntrack.h inside of libnetfilter_conntrack.h, but that isn't
> as clean and prevents anyone from using it directly. Anything in /usr/include
> is fair game for using in an #include, and thus should be extern-C-safe.

Applied. Thanks Phil.

BTW, got no reply on my suggestion about your project name. Thoughts?

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
