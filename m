From: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Subject: Re: Maximum chain name length
Date: Mon, 08 Dec 2003 06:42:33 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1070883753.1932.7.camel@jasiiitosh.nexusmgmt.com>
References: <1070674657.3314.9.camel@jasiiitosh.nexusmgmt.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1070674657.3314.9.camel@jasiiitosh.nexusmgmt.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I have posted this to netfilter-devel at the suggestion of the netfilter
mailing list.

We've posted a large number of screen shots on the project web page
(http://iscs.sourceforge.net/ScreenShots/ScreenShots.html) to show what
the application looks like and why the thirty character limit is a
problem for us.  Any help or input will be greatly appreciated - John

On Fri, 2003-12-05 at 21:02, John A. Sullivan III wrote:
> 	We are developing a GUI manager for iptables and FreeS/WAN for large
> complex deployments.  It is similar to the global management consoles
> from Smartpipes, Solsoft, NetScreen, Checkpoint, etc., except that it
> creates more efficient rules, is significantly easier to manage, is GPL
> rather than a five to six figure product, but does not yet support
> additional services such as IDS and Content Filtering.  (
> http://iscs.sourceforge.net) Actually it is vendor independent and thus
> can manage more than iptables but iptables is our initial target.
> 	We've hit a major problem with the maximum chain name length.  We
> organize our user communities and resource groups into a hierarchical
> structure with inheritance.  These map directly to the iptables chain
> names.  Thus a chain name like 
> 
> AppliedTechnologies/Engineering/NewProducts/SanFranciscoLabs/ProjectB
> 
> is not out of the ordinary.  This runs us up against the 30 character
> limit of chain names very quickly.  Working around this by substituting
> numbers for names or some other such workaround will greatly complicate
> the project and reduce ease of troubleshooting in the field.
> 
> 	Is there any way to extend the maximum allowed chain name length in
> iptables? Thanks - John
-- 
John A. Sullivan III
Chief Technology Officer
Nexus Management
+1 207-985-7880
john.sullivan@nexusmgmt.com
