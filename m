From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: 2.6.20: ipt_owner match and INPUT chain
Date: Fri, 2 Mar 2007 13:59:35 +0100
Message-ID: <200703021359.35886.thomas.jarosch@intra2net.com>
References: <200703020946.20765.thomas.jarosch@intra2net.com>
	<45E81117.1060107@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45E81117.1060107@trash.net>
Content-Disposition: inline
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

Hello Patrick,

On Friday, 2. March 2007, Patrick McHardy wrote:
> > the ipt_owner match of 2.6.20 is not allowed to be used in the INPUT
> > chain.
> >
> > The .hooks entry looks like this:
> > .hooks          = (1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_POST_ROUTING)
> >
> > Back in the days it was allowed to be used in the INPUT chain for
> > TCP/UDP. I've searched the mailinglist archive but couldn't find anything
> > useful. What's the reason behind the change?
>
> The mainline kernel never supported this, you're thinking of the
> owner socketlookup patch, which had multiple issues and was never
> merged.

Thanks for your reply. You're right, on 2.4 I've applied the socketlookup 
patch. I use it to accept incoming connections for a socks v5 proxy.

Socks allows a client to bind a port on the external IP of the server
and then wait for an incoming connection. Would it make sense to write a 
conntrack module which parses the communication between socks client and 
server and then adds the incoming connection to conntrack?

The easier solution would be to patch the socks server to execute a script
if the client requests to bind a port on the server. The connection could be 
added via the userspace conntrack tool, right?

Cheers,
Thomas
