From: Patrick Schaaf <bof@bof.de>
Subject: Re: string match and hex strings
Date: Sat, 1 Mar 2003 07:30:29 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030301063029.GE24025@oknodo.bof.de>
References: <20030228200534.B22879@orthanc.gambrl01.md.comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Michael Rash <mbr@cipherdyne.com>
Content-Disposition: inline
In-Reply-To: <20030228200534.B22879@orthanc.gambrl01.md.comcast.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Michael,

> iptables -A INPUT -m string --string "|45 45|blah" -j LOG
> 
> The problem is that all old versions of iptables will also accept
> the same "|45 45|blah" string, but the hex chars won't mean
> anything; it will just be treated as ascii data.  So we descend
> into version problems...
> 
> My thought is that perhaps it would be better to reinstate my
> original "--hex-string" option and leave the "--string" option to
> just take input as-is.

My thought, exactly. If you don't use a separate --hex-string
option specifier, existing uses may fail where they worked
before. That's a definite NONO, in my opinion, at least for
tools with security implications.

best regards
  Patrick
