From: Patrick Schaaf <bof@bof.de>
Subject: Re: Easy question, how to use stdio.h
Date: Tue, 22 Apr 2003 20:26:07 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030422182607.GC3374@oknodo.bof.de>
References: <ead0eeb154.eb154ead0e@teleline.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "ISLERO77@telefonica.net" <ISLERO77@telefonica.net>
Content-Disposition: inline
In-Reply-To: <ead0eeb154.eb154ead0e@teleline.es>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> And now I was trying to load in a file the source and the dest 
> ports of the packets. 

I would do it this way:

while read sport dport; do
	iptables -t whatever -A WHEREEVER \
		-m TCP --sport $sport --dport $dport -j DOSOMETHING
done <inputfile

and variations thereof.

If you could indicate suitable values of whatever, WHEREEVER, TCP,
and DOSOMETHING, we could maybe try to understand what task you
have to solve. That may lead to suitable proposals on how to
proceed.

Questions:

- do you really mean 'source AND dest ports'? That's what leads me
  to the above iptables command.
- when the file changes, what do you expect to happen?

best regards
  Patrick
