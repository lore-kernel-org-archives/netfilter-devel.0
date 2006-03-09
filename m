From: Peter Christensen <pch@coolsystems.dk>
Subject: Statefull SOCKS filter
Date: Thu, 09 Mar 2006 13:16:37 +0100
Message-ID: <44101CA5.3070004@coolsystems.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi,

I'm currently in the development of a transparent firewall bridge, whose 
sole purpose is to filter our everything but LAN traffic and traffic for 
a list of privileged servers on the Internet. Since it is meant to work 
on an bunch of different network configurations out-of-box, it must be 
able to detect and filter proxy traffic as well.

My problem is specifically with making a SOCKS filter. I've done it in 
user-space with great success (basically a state machine), but I 
naturally want this to be done in iptables. And here is the real question:

Are the any preferred "smart" way of doing this kind of statefull 
filters, where some upper software layer handles the actual connection 
for me, if you follow me? At first I thought connection tracking was the 
way to go, but apparently this is primarily for temporarily accepting a 
given connection based on the content of another connection.
I CAN solve the whole thing just by making a basic match filter, having 
my own array of current connections with their appropriate SOCKS state 
(This is basically what my user-space equivalent does), but I think that 
it is quite a lot of work, especially if a similar thing is already done 
elsewhere in the kernel. After all, the bridge does not have a 
tremendous amount of processing power!

I apologize if I'm just too uninformed, but I've so far failed to find 
any documentation of how to make an actual statefull filter, whose 
purpose was NOT to help out NAT etc.

-- 
Best regards

Peter Christensen

Developer
------------------
Cool Systems ApS

Tel: +45 2888 1600
  @ : pch@coolsystems.dk
www: www.coolsystems.dk
