From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Question + patch: FTP conntrack fails to recognize a PORT command
Date: Sat, 29 Nov 2003 19:44:30 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311291942350.20615-100000@filer.marasystems.com>
References: <1069783352.19640.104.camel@ferrari>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Peter Parkkali <peter.parkkali@iki.fi>
In-Reply-To: <1069783352.19640.104.camel@ferrari>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On 25 Nov 2003, Peter Parkkali wrote:

> The bug can be avoided by commenting out the "return NF_ACCEPT;"
> from line 298 (uhh... 2.4.22 source, not cvs, sorry). This allows
> the rest of help() to find the "PORT" string, do NAT etc. 
> 
> This works, but since I don't really understand the code, I thought
> somebody could advice me on the sanity of this approach? ;) Is it safe
> to bypass this check is could the actual bug be somewhere else?

It seems iptables makes assumptions on how the PORT command will be sent
which is not true with this client..

Can you please save a "tcpdump -s 1600 -w dump.out host
ip.of.client.station" of the traffic sent by this client, then use ngrep 
to inspect what the client is sending.

Regards
Henrik
