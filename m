From: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Subject: Re: TTL patch buggy?
Date: Wed, 07 Jan 2004 14:04:36 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1073502275.16972.10.camel@jasiiitosh.nexusmgmt.com>
References: <Pine.LNX.4.44.0401071709030.4717-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>, netfilter@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.44.0401071709030.4717-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2004-01-07 at 11:16, Henrik Nordstrom wrote:
> On Tue, 6 Jan 2004, John A. Sullivan III wrote:
> 
> > <snip>.  We are
> > planning to not only use the TTL patch in ISCS to create stealth
> > firewalls but also to secure communications between internal and DMZ
> > systems by allowing admins to set TTL on a per service basis to allow
> > the DMZ <-> Internal flow to only have enough life to live on the site
> > and not to be set anywhere else on the Internet.  We think this is a
> > pretty interesting feature and hence are keen on the TTL patch working. 
> 
> Take care to never increase the TTL value however.
> 
> There is no technical problems from artificially decreasing the TTL, but 
> increasing should never be done unless you are 200% sure on what you are 
> doing (and even then you should not).
> 
> The TTL target is dangerous in the sense that it allows the packet ttl to
> be set freely with no restrictions. But if combined with a "-m ttl
> --ttl-gt NEWVALUE" then you should be safe.
> 
> Harald: What do you think about making the patch civilised and restricting
> the TTL to be set to lower values only eleminating the need of the above
> safeguard match? (simply change "new_ttl != iph->ttl" to "new_ttl < 
> iph->ttl")
> 
> Regards
> Henrik

Thank you very much but could you please explain this a bit more.  Oskar
Andreasson's tutorial explicitly mentions doing this, i.e., incrementing
TTL and we thought it was a good idea.  We certainly want to change our
ways if this is dangerous.  Here is the excerpt from the tutorial:

The --ttl-inc option tells the TTL target to increment the Time To Live
value with the value specified to the --ttl-inc option. This means that
we should raise the TTL value with the value specified in the --ttl-inc
option, and if we specified --ttl-inc 4, a packet entering with a TTL of
53 would leave the host with TTL 56. Note that the same thing goes here,
as for the previous example of the --ttl-dec option, where the network
code will automatically decrement the TTL value by 1, which it always
does. This may be used to make our firewall a bit more stealthy to
trace-routes among other things. By setting the TTL one value higher for
all incoming packets, we effectively make the firewall hidden from
trace-routes.
-- 
John A. Sullivan III
Chief Technology Officer
Nexus Management
+1 207-985-7880
john.sullivan@nexusmgmt.com
---
If you are interested in helping to develop a GPL enterprise class
VPN/Firewall/Security device management console, please visit
http://iscs.sourceforge.net 
