From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: Re: Feasability of Protocol Filtering
Date: Sat, 26 Apr 2003 10:41:22 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200304260041.h3Q0fNr20483@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Patrick Schaaf" <bof@bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Good question;

> I've got a heretic question:
> 
> > Examples:
> > Identify and DENY SSH traffic regardless of port
> 
> How do you cope with an ftp transfer of a tcpdump capture of some
> earlier SSH traffic?

But wouldn't this be resolved by only doing a single pass through of
the detection code, per stream/conntrack?  Ie;  if the ftp data is related
to an existing ftp stream, then it won't have a detection attempt made
on it by the proto_detect module ... surely ...

This whole thread on protocol detection, particularly with protocols like
P2P, is sweet ...  very cool stuff ... very useful.




--
Ian Latter
Internet and Networking Security Officer
Macquarie University
