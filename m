From: Patrick McHardy <kaber@trash.net>
Subject: Re: policy routing on locally generated packets
Date: Tue, 26 Aug 2003 15:06:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F4B5B5D.2040300@trash.net>
References: <1061813400.1289.36.camel@drs0.manchotnetworks.net>	<3F4A01BE.1090805@trash.net>  <3F4A2795.3030805@trash.net> <1061837608.1333.9.camel@drs0.manchotnetworks.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "lartc@manchotnetworks.net" <lartc@manchotnetworks.net>
In-Reply-To: <1061837608.1333.9.camel@drs0.manchotnetworks.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Charles,

lartc@manchotnetworks.net wrote:

> So, I suppose (and humbly suggest) that the logical extension of this
>
>thread would be that netfilter allow control over the output routing
>process itself, thereby granting the administrator a means of
>influencing route selection, src address, interface, etc.
>
>iptables --append OUTROUTE ...
>

There i a ROUTE target, maybe that helps. Before i can discuss this
further i have to do some testing myself, my first attempt to route
by netfilter mark wasn't successful at all, so please give me a day
or two.

Bye,
Patrick
