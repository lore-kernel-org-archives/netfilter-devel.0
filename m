From: Mike Accetta <maccetta@laurelnetworks.com>
Subject: Re: change in behavior of OUTPUT chain rule in 2.6.19
Date: Thu, 31 May 2007 16:09:45 -0400
Message-ID: <13313.1180642185@mdt.dhcp.pit.laurelnetworks.com>
References: <Pine.LNX.4.61.0705312149090.11140@yvahk01.tjqt.qr>
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: Your message of "Thu, 31 May 2007 21:49:35 +0200."
	<Pine.LNX.4.61.0705312149090.11140@yvahk01.tjqt.qr>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt writes:
> On Dec 14 2006 13:30, Mike Accetta wrote:
> >
> > Between 2.6.18 and 2.6.19 (and 2.6.19.1) we've observed that a reject rule 
> on
> > the OUTPUT chain no longer causes a connection attempt to abort immediately
> > with "Connection refused".  As a specific example, this rule
> >
> > iptables -A  OUTPUT -p tcp --destination-port 23 \
> > --destination 10.0.20.1  -j REJECT --reject-with tcp-reset
> 
> I cannot reproduce this with 2.6.20.2. Have you tried any newer kernel?

This was filed as Bugzilla #7716 and fixed by Patrick McHardy in 2.6.20.

Did I mess up by not also confirming back to the list that the bug was
fixed by the patch provided by Patrick?  I think at the time I just
moved it to Bugzilla because the list post had produced no reaction.
--
Mike Accetta

ECI Telecom Ltd.
Data Networking Division (previously Laurel Networks)
