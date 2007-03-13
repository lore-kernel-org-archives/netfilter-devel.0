From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnetfilter_conntrack question
Date: Tue, 13 Mar 2007 10:41:30 +0100
Message-ID: <45F671CA.6010401@netfilter.org>
References: <45F4B34F.3020007@ipom.com> <45F527F2.40404@netfilter.org>
	<45F6558A.2070601@ipom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Phil Dibowitz <phil@ipom.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F6558A.2070601@ipom.com>
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
> Another question - is there a way to get the nfct flags map outside of a
> hook? I don't see a way to pull it down, but I could be missing it.

Sorry, I don't understand what you mean.

BTW, I suggest you to have a look a new_api_test.c under utils/ to get
quick look on the new API. The old API is deprecated and will vanish
sooner or later, new apps must use the new API.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
