From: "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>
Subject: Re: MSN helper module
Date: 17 Dec 2002 22:52:12 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1040161933.615.71.camel@exile>
References: <200212171647.gBHGkxmD003537@sandelman.ottawa.on.ca>
	<002801c2a5fb$1eb92660$152ea8c0@maincomp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Michael Richardson
	 <mcr@sandelman.ottawa.on.ca>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Carlos Fernandez Sanz <cfs-netfilter@nisupu.com>
In-Reply-To: <002801c2a5fb$1eb92660$152ea8c0@maincomp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2002-12-17 at 19:35, Carlos Fernandez Sanz wrote:
> Yes, it needs some support for file tranmission, voice, etc. The protocol
> works a lot like FTP when using PORT (active) connections. The initiator
> client sends its IP address and a port number for the other end to connect
> to. For basic messaging it doesn't need any special NAT support, though -
> the reason being that all connections are outgoing and there are no related
> children connections.
> 
> So it is not a lot of work but it needs to be done. I haven't found anything
> about it so I'm assuming no one has started any work, so I'll do it myself.
> Anyway it's pretty much a one man job.
> 

Hi Carlos,

If you're thinking about this, these links will be of great help:

http://www.hypothetic.org/docs/msn/index.php
http://www.hypothetic.org/docs/msn/ietf_draft.php
http://www.venkydude.com/articles/msn.htm

I started working on a connection tracking module for this, but 
really didn't go any further than adding the basic conntrack/nat
helper framework. 

If you're really serious about this, I can send you a diff of
the basic conntrack/nat module to get you started. Just let me
know.

One thing to watch out for when writing a conntracker for
this, is that the MSN packet that should add an expectation for
a file transfer should contain data that like this:

...
Invitation-Command: ACCEPT
Invitation-Cookie: 33267
IP-Address: 10.44.102.65
Port: 6891
AuthCookie: 93301
...

Now the problem is that MSN also allows some chat-like protocol
over the same port.

If you're writing a conntracker, you must make sure that you
are not parsing the "Messaging" packets as file transfer
requests. Otherwise the code has a security vulnerability 
where a specially crafted "Messaging" packet can add a firewall
connection expectation. When I realized my module was going to
have to detect this, I realized this wasn't going to be a
"weekend project" kind of thing and sort of gave up on it
for now. It would be great if you picked up the slack !

Regards,
Filip
