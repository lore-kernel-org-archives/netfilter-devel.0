From: "Andrew Hall" <temp02@bluereef.com.au>
Subject: RE: conntrack clarification
Date: Mon, 6 Aug 2007 18:54:29 +1000
Message-ID: <24966838.281186390464437.JavaMail.root@localhost>
References: <3434740.221186389567173.JavaMail.root@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "'Eric Leblond'" <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <3434740.221186389567173.JavaMail.root@localhost>
Content-Language: en-au
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

> This is linked with your ruleset. The point to consider is that for the
> conntrack NEW is not equivalent to SYN packet for TCP. If you only
> filter on NEW, then packet from the previously existing connection will
> be classified as NEW and trigger the creation of a new valid entry.

This is true, but how? I no longer have a "new" rule to allow connection. Here's the logic of what I'm trying to do:

1. First, set up SSH connection with the following ruleset:

- add a rule matching "established and related" connections to be allowed
- add a rule matching "new" connections from host for SSH to be allowed
- Policy is drop all

2. SSH is connected from host running 'top' to keep the session active

3. delete the "new" connection rule and 'conntrack -F' to flush the existing connections.

At this point I would have thought the conntrack table doesn't know the existing connection is "established" because the table entry is gone and without the "new" rule providing connection establishment, the session should be lost?




"Blue Reef disclaimer: This electronic message transmission contains information that is confidential or privileged. The information is intended to be for the use of the individual or entity named above. If you are not the intended recipient, be aware that any disclosure, copying, distribution, or use of the contents of this information is prohibited. If you have received this transmission in error, please notify us by telephone immediately."

Scanned by Sonar. 
Date: 2007-08-06 18:54:24
From: temp02@bluereef.com.au
To: netfilter-devel@lists.netfilter.org
Mail id: challenge-63904640371
