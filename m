From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Port information.
Date: Mon, 19 Jan 2004 21:31:59 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401192124330.15376-100000@filer.marasystems.com>
References: <400C277C.8030504@netlab.hut.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Emmanuel Guiton <emmanuel@netlab.hut.fi>
In-Reply-To: <400C277C.8030504@netlab.hut.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 19 Jan 2004, Emmanuel Guiton wrote:

> I'm creating a target for which I specify "-p tcp --dport XX" from the 
> user-space program. How can I know the port number from the check 
> function in the target? Where is it stored? I guess I can't access it 
> via the "const struct ipt_entry *e".

You probably can get it from the ipt_entry, but this is not something I 
would recommend attempting as it requires iterating over the included 
matches to find the information you require. For some information see the 
check_entry() function.

What you can do in more sane manners is to add a target argument allowing
the required information to be specified to your target in addition to the
tcp match.

Regards
Henrik
