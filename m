From: Patrick McHardy <kaber@trash.net>
Subject: Re: Policy match with a bridge
Date: Sun, 15 Aug 2004 14:55:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <411F5D5E.4000001@trash.net>
References: <411EAF08.3000401@shorewall.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tom Eastep <teastep@shorewall.net>
In-Reply-To: <411EAF08.3000401@shorewall.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Tom Eastep wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> I'm seeing odd behavior of policy match when used with a bridge.
>
> wookie:/backup # uname -a
> Linux wookie 2.6.5-7.104-default #1 Wed Jul 28 16:42:13 UTC 2004 i586
> i586 i386 GNU/Linux

Have you applied the ipsec+netfilter patches ? Without them, packets are
only seen encrypted in the OUTPUT chain.

Regards
Patrick
