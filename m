From: Nuutti Kotivuori <naked@iki.fi>
Subject: Re: Floods
Date: Mon, 15 Mar 2004 17:14:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <877jxmuopm.fsf@aka.i.naked.iki.fi>
References: <200403141930.29602.alchemyx@uznam.net.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Micha wrote:
> What do you recommend? Unfortunately connlimit does not work with
> UDP packets (no wonder - UDP is conection less). What should I do? I
> even thought about switch to FreeBSD (sic! :<).

See if the 'dstlimit' would help in your case. It is in patch-o-matic.

-- Naked
