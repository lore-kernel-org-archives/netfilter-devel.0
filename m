From: Patrick Schaaf <bof@bof.de>
Subject: Re: policy routing on locally generated packets
Date: Mon, 25 Aug 2003 21:07:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030825190750.GH423@oknodo.bof.de>
References: <1061813400.1289.36.camel@drs0.manchotnetworks.net> <3F4A01BE.1090805@trash.net> <3F4A2795.3030805@trash.net> <1061837608.1333.9.camel@drs0.manchotnetworks.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
  netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "lartc@manchotnetworks.net" <lartc@manchotnetworks.net>
Content-Disposition: inline
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

> This would provide a way to fiddle with the packet properties without
> the neccesity of changing bind() in a specific application ... or would
> it? 

Regarding this path, two comments:

1) you can most easily LD_PRELOAD a small bit of library which replaces
bind() and friends, and does the thing you want.
2) the chbind functionality of http://www.solucorp.qc.ca/miscprj/s_context.hc
is a somewhat more / somewhat less intrusive method.

What about mangle/PREROUTING? Doesn't it / shouldn't it sit before a
routing decision for locally generated packets?

best regards
  Patrick
