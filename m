From: Matt Skidmore <fox@woozle.org>
Subject: Feasability of Protocol Filtering
Date: Tue, 22 Apr 2003 16:25:11 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44+maildir.0304221620090.1447-100000@woozle.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


I have gained some interest in adding a new module to the netfilter code
for filtering by protocol. However, I do not know how realistic this
project would be. I have not found any projects similar to it as of yet.
But, I would like to be able to REJECT, DENY, or REDIRECT packets based on
the protocol of their connection.

Examples:
Identify and DENY SSH traffic regardless of port

Identify HTTP traffic regardless of port and REDIRECT/reroute it
transparently through another route or hand it to a transparent proxy.

I believe Cisco has a similar feature in their IOS called protocol
discovery (not 100% sure)
(http://www.cisco.com/en/US/products/sw/iosswrel/ps1839/products_feature_guide09186a0080153efc.html)

If it isn't workable that's fine, I'm just throwing in an idea for
something I might like to contribute to. I've not worked on any parts of
the kernel and I would need to shake the dust off my C and and TCP
knowledge, but I'm willing to jump into the pit and give it a try.

Please be gentle, first post to this list. This is just a probe of a
peliminary idea, if there is some hope for the idea I would continue to
brainstorm and elaborate on other features that may be achievable.

-Matt
