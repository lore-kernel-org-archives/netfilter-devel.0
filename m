From: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Subject: Re: Maximum chain name length
Date: Thu, 11 Dec 2003 08:54:10 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1071150850.1871.37.camel@jasiiitosh.nexusmgmt.com>
References: <1070674657.3314.9.camel@jasiiitosh.nexusmgmt.com>
	 <1070883753.1932.7.camel@jasiiitosh.nexusmgmt.com>
	 <20031211130446.GA22826@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031211130446.GA22826@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Yes, that's what we have now done.  It was just a major, unexpected
rewrite of a lot of complex code.  We do some pretty complex
manipulation in our effort to move security administration away from
individual "gateway" devices and make it a function of network policy. 
So when an administrator says, "Give Sales access to Sales Data anywhere
in the world and deny access for all of my users worldwide to the latest
virus password stealing target server", we've got to figure out what
that means in rules and chains on every device throughout our global
network and then distribute it.

We should be finished with debugging the work around today and then on
with the rest of the project.  By the way, if anyone is interested in
assisting with such an enormous project, we can use all the help we can
get.  The pertinent sites are http://iscs.sourceforge.net and
http:sourceforge.net/projects/iscs.  Please don't be put off by the 0%
activity.  Sourceforge's CVS stat tracker is broken.  It is a very
active project.

Thanks again, Harald - John

On Thu, 2003-12-11 at 08:04, Harald Welte wrote:
> On Mon, Dec 08, 2003 at 06:42:33AM -0500, John A. Sullivan III wrote:
> > I have posted this to netfilter-devel at the suggestion of the netfilter
> > mailing list.
> > 
> > We've posted a large number of screen shots on the project web page
> > (http://iscs.sourceforge.net/ScreenShots/ScreenShots.html) to show what
> > the application looks like and why the thirty character limit is a
> > problem for us.  Any help or input will be greatly appreciated - John
> 
> Well, you can recompile the kernel and the iptables program, changing
> the IPT_FUNCTION_MAXNAMELEN constant (defined in
> include/linux/netfilter_ipv4/ip_tables.h) to something more than 30
> chars.
> 
> We will certainly not do this by default in the kernel, since it would
> artificially bloat all the iptables internal structures.
> 
> but since you are building a higher layer anyway (and I doubt that you
> don't want more abstractions than the simple 'chain' approach we have),
> you could implement a translation layer for chain names.  So the User
> gets shown some indefinitely long chain name, but the
> iptables-chain-name is used more like some id/key that is looked up in a translation table (that could even be automagically created).
> 
> > -- 
> > John A. Sullivan III
>  
-- 
John A. Sullivan III
Chief Technology Officer
Nexus Management
+1 207-985-7880
john.sullivan@nexusmgmt.com
