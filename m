From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.20: ipt_owner match and INPUT chain
Date: Sat, 03 Mar 2007 17:24:36 +0100
Message-ID: <45E9A144.1050600@trash.net>
References: <200703020946.20765.thomas.jarosch@intra2net.com>	<45E81117.1060107@trash.net>
	<200703021359.35886.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200703021359.35886.thomas.jarosch@intra2net.com>
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

Thomas Jarosch wrote:
> Hello Patrick,
> 
> On Friday, 2. March 2007, Patrick McHardy wrote:
> 
>>The mainline kernel never supported this, you're thinking of the
>>owner socketlookup patch, which had multiple issues and was never
>>merged.
> 
> 
> Thanks for your reply. You're right, on 2.4 I've applied the socketlookup 
> patch. I use it to accept incoming connections for a socks v5 proxy.
> 
> Socks allows a client to bind a port on the external IP of the server
> and then wait for an incoming connection. Would it make sense to write a 
> conntrack module which parses the communication between socks client and 
> server and then adds the incoming connection to conntrack?

Not sure if its worth the effort. It also doesn't seem to fit the helper
model really well since the expectation is only relevant for the proxy
itself, not for the firewalls in between. Or does the proxy open a new
connection to the client when an external connection arrives?

> The easier solution would be to patch the socks server to execute a script
> if the client requests to bind a port on the server. The connection could be 
> added via the userspace conntrack tool, right?

That should work. We could also add support for helperless expectations
for this, which will properly deal with NAT automatically.
