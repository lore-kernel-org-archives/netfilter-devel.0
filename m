From: Kevin White <kwhite@secureinteriors.com>
Subject: "Proper" way to transparent proxy?
Date: Wed, 09 Oct 2002 16:11:05 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DA48D59.7060109@secureinteriors.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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

Short story: I need to write a transparent, application level proxy. 
I've searched through the mailing lists for information on how to do it, 
and find conflicting information about things like "stateless 
redirection" patches by Bazsi, and comments that they would no longer be 
maintained because something better was coming.  But I can't tell if 
that something better happened, or what it is.

If there's something I should be looking at, I'd be greatful for pointers.

Long story: we have an OpenBSD based firewall that uses this particular 
application level proxy, using IPFilter's transparent proxy support.  We 
are investigating rehosting the whole thing on Linux (for the record, MY 
first choice anyways :) and this is the hardest problem so far:

I need to find the address and port the outgoing connecion was 
originally heading to.  I'm assuming this is what's meant by the 
stateless redirection patches and such, but those (admittedly) didn't 
even come with documentation.

I'm starting from scratch here: I've never programmed to Netfilter 
before.  What I need is fairly simple, I think, but I don't know how to 
get started.

What we had on IPFilter was a "redirect" rule that redirected all 
connections to external hosts on this specific port to a specific port 
on the firewall machine, where a proxy program was waiting for it.  We 
then used IPFilter system calls to retreive where the connection was 
heading.

I expect that I'll be able to reuse most of my code: just the lookup 
part needs to change.

Thanks in advance for any help/pointers.  I'll attempt to collect what 
I've learned and post it, so that it ends up in the archives and more 
people like me don't have to ask.  :)

Kevin
