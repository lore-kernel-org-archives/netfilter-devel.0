From: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Subject: Re: Creating rules without the /sbin/iptables command?
Date: Thu, 18 Mar 2004 09:12:27 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1079619146.2004.26.camel@localhost>
References: <Pine.LNX.4.44.0403180022440.15641-100000@filer.marasystems.com>
	 <40594EFE.2000004@nk.nl> <1079609346.2009.9.camel@localhost>
	 <40599B7D.8020804@nk.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Victor Julien <victor@nk.nl>
In-Reply-To: <40599B7D.8020804@nk.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2004-03-18 at 07:52, Victor Julien wrote:
> John A. Sullivan III wrote:
> 
> <snip>
> 
> >>
<snip>
> >>But the easiest way is to recreate the initial ruleset with the updated 
> >>rules would be:
> >>
> >>*filter
> >>:FORWARD DROP
> >>-A FORWARD -p tcp -s 192.168.0.1 --dport 80 -j ACCEPT
> >>-A FORWARD -p tcp -s 192.168.0.4 --dport 80 -j ACCEPT
> >>-A FORWARD -p tcp -s 192.168.0.3 --dport 80 -j ACCEPT
> >>COMMIT
> >>
> >>and then just call iptables-restore. This way i wont have to calculate 
> >>where i want to insert the rules, this can be quite complex on many 
> >>changes in large rulessets. Is this correct?
> > 
> > Yes, although when ISCS is released (http://iscs.sourceforge.net), it
> > will provide an alternative to having to track rule order (massive
> > oversimplification here but it is not the topic at hand).
> 
> But how will ISCS handle this problem? Will it also create input for 
> iptables-restore? Or do you have some other method?
Yes, it creates input files for iptables restore and is also able to
create configuration files for other firewalls (as well as the VPN
configuration, the router configuration, the NAT configuration and any
local DHCP configuration and, hopefully soon, all the layer2
configuration for the individual gateways). However, rather than relying
exclusively upon rule order, it uses an approach we call "Best Match". 
This allows us to automate the creation of all rules from a high level
description of the environment.  The idea is to eliminate the need for
an administrator to create rules.  Instead, we interpret the
environment, e.g., "give these three teams access to the new joint
development project data", and create consistent rules for access
control, user authentication, encryption, data authentication, routing,
NAT, etc, to produce that environment.
> 
> > 
> >>The last method should still be way faster than my current method, i 
> >>guess. Is this right?
> > 
> > I have found it to be dramatically faster - John
> 
> Good!
> 
> Regards,
> Victor
> 
> > 
> >>Regards,
> >>Victor
-- 
John A. Sullivan III
Chief Technology Officer
Nexus Management
+1 207-985-7880
john.sullivan@nexusmgmt.com
