From: Patrick McHardy <kaber@trash.net>
Subject: Re: policy routing on locally generated packets
Date: Tue, 26 Aug 2003 15:12:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F4B5CDA.8090801@trash.net>
References: <1061813400.1289.36.camel@drs0.manchotnetworks.net> <3F4A01BE.1090805@trash.net> <3F4A2795.3030805@trash.net> <1061837608.1333.9.camel@drs0.manchotnetworks.net> <20030825190750.GH423@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "lartc@manchotnetworks.net" <lartc@manchotnetworks.net>,
 netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20030825190750.GH423@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick Schaaf wrote:

>What about mangle/PREROUTING? Doesn't it / shouldn't it sit before a
>routing decision for locally generated packets?
>

No locally generated packets don't pass the PRE_ROUTING hook. There
is no way to mangle these packets before routing.

>best regards
>  Patrick
>

dito ;)
