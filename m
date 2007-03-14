From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: add extern "C" {..} to libnetfilter_conntrack headers?
Date: Wed, 14 Mar 2007 14:33:14 +0100
Message-ID: <45F7F99A.3090608@netfilter.org>
References: <20070314004052.GC25929@ipom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Phil Dibowitz <phil@ipom.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070314004052.GC25929@ipom.com>
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
> Is there a reason that there aren't extern "C" {} enclosures in the
> libnetfilter_conntrack header files?

Well, the only reason that I can find is that I think that low-level 
stuff should be written in C, however someone could come here and say 
that wants to write a graphical interface for conntrack in qt, which is 
not so low-level stuff.

If nobody objects here, send me the patch. I'd accept a similar patch 
for the other libnetfilter_* libraries. Thanks.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
