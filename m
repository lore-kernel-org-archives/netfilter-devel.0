From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: RE: conntrack clarification
Date: Mon, 6 Aug 2007 11:07:16 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708061106240.1735@fbirervta.pbzchgretzou.qr>
References: <3434740.221186389567173.JavaMail.root@localhost>
	<24966838.281186390464437.JavaMail.root@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, 'Eric Leblond' <eric@inl.fr>
To: Andrew Hall <temp02@bluereef.com.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <24966838.281186390464437.JavaMail.root@localhost>
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


On Aug 6 2007 18:54, Andrew Hall wrote:
>
>> This is linked with your ruleset. The point to consider is that for the
>> conntrack NEW is not equivalent to SYN packet for TCP. If you only
>> filter on NEW, then packet from the previously existing connection will
>> be classified as NEW and trigger the creation of a new valid entry.
>
>This is true, but how? I no longer have a "new" rule to allow connection. Here's the logic of what I'm trying to do:

Fix your ruleset. From:

-m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

to:

-m conntrack --ctstate ESTABLISHED -j ACCEPT
-m conntrack --ctstate NEW -p tcp --syn -j ACCEPT
-m conntrack --ctstate NEW -p udp -j ACCEPT
# (and more for SCTP/DCCP if you need that)

>
>1. First, set up SSH connection with the following ruleset:
>
>- add a rule matching "established and related" connections to be allowed
>- add a rule matching "new" connections from host for SSH to be allowed
>- Policy is drop all
>
>2. SSH is connected from host running 'top' to keep the session active
>
>3. delete the "new" connection rule and 'conntrack -F' to flush the existing connections.
>
>At this point I would have thought the conntrack table doesn't know the existing connection is "established" because the table entry is gone and without the "new" rule providing connection establishment, the session should be lost?
>
>
>
>
>"Blue Reef disclaimer: This electronic message transmission contains information that is confidential or privileged. The information is intended to be for the use of the individual or entity named above. If you are not the intended recipient, be aware that any disclosure, copying, distribution, or use of the contents of this information is prohibited. If you have received this transmission in error, please notify us by telephone immediately."
>
>Scanned by Sonar. 
>Date: 2007-08-06 18:54:24
>From: temp02@bluereef.com.au
>To: netfilter-devel@lists.netfilter.org
>Mail id: challenge-63904640371
>

	Jan
-- 
