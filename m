From: Johan Ankarloo <johan.ankarloo@volvo.com>
Subject: Re: DNAT/SNAT and logging
Date: Thu, 22 Jan 2004 12:12:02 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1074769922.22583.14.camel@ankarloo.got.volvo.net>
References: <Pine.LNX.4.44.0401221123250.23668-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0401221123250.23668-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

So then you agree that this is a problem that has to be fixed one way or
another?

I don't want to be a pain in the butt here but this is a really big
problem for me. When i have problem with Nat or mangle ( either i
haven't understood iptables correctly or there could be a bug ) i can't
really tell what has happened with the packet. Or if i get a court order
to get the person accessing some specific machine at a specific time i
can't rely on the log since all the necessary information about that
connection isn't in the logs. 

Regards
Johan

On Thu, 2004-01-22 at 11:25, Henrik Nordstrom wrote:
> On Thu, 22 Jan 2004, Johan Ankarloo wrote:
> 
> > Do you understand why this is important?
> 
> Yes. The existing LOG target is a mess if NAT is used.
> 
> Regards
> Henrik
