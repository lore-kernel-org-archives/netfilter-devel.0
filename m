From: "Richard Pickett" <Richard.Pickett@CSRTechnologies.com>
Subject: Strange FORWARD problem
Date: Thu, 29 Dec 2005 11:08:05 -0600
Message-ID: <010601c60c9a$71356760$1101a8c0@quebec>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

I tried posting this in the std netfilter list, but no response. I'm
hoping you guys can give me some good debugging instructions.

Stock RH FC4 kernel, 2.6.11 - no modification or patches.

I have a script that generates the correct iptables settings from a
configuration file. Basic NAT, Routing, and IN/OUT capability.

Everything that comes into INPUT, OUTPUT, and FORWARD goes through the
following logic:

1. We check the state to see if it is RELATED,ESTABLISHED, if yes, jump
ACCEPT
2. Log, we log the inbound packet, indicating which chain it is coming
on (INPUT, OUTPUT, FORWARD).
3. check against a "DROP" list of addresses we reject all traffic
to/from.
4. check against "allow" rules and ACCEPT if allowed
5. log and default DROP the packet.

Well, we've run into an intermittent problem. What we are seeing is
after different amounts of time (sometimes a few hours, sometimes
several weeks) suddenly forwarding breaks. It just doesn't forward
anything that is D or S NATed.

We iptables-save > file and check it all over, and the logic is all in
place just like I list above. At a minimum things hitting the forward
chain should at least get logged, that's the first action after the
RELATED/ESTABLISHED check, but they don't, the only logging is INPUT and
OUTPUT.

We can turn right around and `cat iptables-save.file | iptables-restore`
and "magically" it all starts working again. So it doesn't appear to be
a problem with the rules at all.

It's like it just needs to be bumped every once in a while to make it
keep running.

Any ideas? Are there some kernel logging things we can try or other
things we need to be looking at to determine this problem?

We don't touch anything except the iptables-restore to make it work
again, so things like /proc/sys/net/ipv4/ip_forward aren't touched at
all after it breaks to make it work.

Thanks for any ideas and all help!



Richard W. Pickett, Jr.
President, CSR Technologies .com, Inc.
Richard.Pickett@CSRTechnologies.com
www.CSRTechnologies.com
Office - (270) 746-0324
Cell    - (270) 303-9154
