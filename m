From: Patrick McHardy <kaber@trash.net>
Subject: Re: NFLOG --nflog-group bug?
Date: Sat, 17 Mar 2007 11:54:33 +0100
Message-ID: <45FBC8E9.1060401@trash.net>
References: <45FB2175.1050503@nitrosecurity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Dan Purcell <dpurcell@nitrosecurity.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45FB2175.1050503@nitrosecurity.com>
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

Dan Purcell wrote:
> I may have found a bug with the NFLOG target.  I am trying to use NFLOG
> to log packets to a ulogd program using ip6tables.  I am using iptables
> version 1.3.7, and linux kernel version 2.6.20.

Try the latest SVN version, there was a bug in 1.3.7. We'll release
1.3.8 soon.
