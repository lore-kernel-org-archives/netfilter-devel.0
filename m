From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: kernel rule insertion question/suggestion
Date: Wed, 7 Jan 2004 17:08:19 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401071706160.4717-100000@filer.marasystems.com>
References: <1073385010.1106.15.camel@sin.nobugconsulting.ro>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrascu Eugeniu <epatrascu@go.ro>
In-Reply-To: <1073385010.1106.15.camel@sin.nobugconsulting.ro>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 6 Jan 2004, Patrascu Eugeniu wrote:

> Hi,
> 
> As explained by a list member a while ago, to insert a netfilter rule in
> the running kernel the following things happen:
> 	I. the whole ruleset is being downloaded in userspace
> 	II. the rules are checked for loops/errors/whatever and the new rule is
> added to the chain.
> 	III. then the whole ruleset is uploaded back into the running kernel.
> 	IV. the steps above are repeated for each and every rule added.


If you want to avoid this then use iptables-restore to load your ruleset. 
This compiles the ruleset and if successful installs it with one call to 
the kernel.

> I was wondering (in case what I wrote above is really true) if there
> would be a good ideea to have a userspace rule compiler that can check
> for errors in the rules and then just upload them in the kernel, without
> using the mecanism described above.

Having a "dry-run" iptables-restore type command would perhaps be useful
to verify the syntax of a ruleset.

Regards
Henrik
