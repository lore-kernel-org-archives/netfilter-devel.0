From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: iptables compilation (or user :) error
Date: Wed, 10 Sep 2003 16:15:29 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0309101613500.7167@dns.toxicfilms.tv>
References: <Pine.LNX.4.44.0309101645580.2834-100000@mx.nextra.ro>
 <Pine.LNX.4.51.0309101554140.6867@dns.toxicfilms.tv> <3F5F30E5.9060402@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Gergely Imre <gimre@nextra.ro>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3F5F30E5.9060402@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> The CLASSIFY target is already submitted to 2.6 and will be submitted to
> 2.4 soon, I believe.
Ah, ok, so for now, Gergely either

1) apply the patch, remember to add chmod u+x .CLASSIFY-test
or
2) patch your kernel with the CLASSIFY target.

> Patrick
Maciej
