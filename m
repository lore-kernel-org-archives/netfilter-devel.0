From: "lartc@manchotnetworks.net" <lartc@manchotnetworks.net>
Subject: Re: policy routing on locally generated packets
Date: 25 Aug 2003 20:53:27 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1061837608.1333.9.camel@drs0.manchotnetworks.net>
References: <1061813400.1289.36.camel@drs0.manchotnetworks.net>
	<3F4A01BE.1090805@trash.net>  <3F4A2795.3030805@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3F4A2795.3030805@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Again patrick,


On Mon, 2003-08-25 at 17:13, Patrick McHardy wrote:
> I don't know what i was thinking, this patch is going to confuse
> all kinds of stuff (especially conntrack & nat). Sorry.
> Patrick

Please don't be sorry -- your insight is so valuable.

I had a suspician that performing a full lookup afterward could create
more problems than it would solve.

So, I suppose (and humbly suggest) that the logical extension of this
thread would be that netfilter allow control over the output routing
process itself, thereby granting the administrator a means of
influencing route selection, src address, interface, etc.

iptables --append OUTROUTE ...

This would provide a way to fiddle with the packet properties without
the neccesity of changing bind() in a specific application ... or would
it? 

Sleep Well.

Charles
