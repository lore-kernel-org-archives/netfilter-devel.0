From: gideon olam <gideon@gideonolam.com>
Subject: Re: Application interface
Date: 24 Jun 2003 08:51:44 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1056466303.14572.54.camel@skinny.gideonolam.com>
References: <1056408903.3659.13.camel@skinny.gideonolam.com>
	 <200306241633.56809.fabrice@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200306241633.56809.fabrice@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2003-06-24 at 14:33, Fabrice MARIE wrote:
> Hello,
> 
> On Monday 23 June 2003 18:55, gideon olam wrote:
> > Is there an interface or mechanism either in place today or planned for
> > the future which allows for application level control?  Meaning instead
> > of all apps being being allowed to use well known services like http,
> > limiting access to a subset of applications?
> > I'm interested in Linux's ability to provide some of the personal
> > firewall capabilities seen on windows systems.  Specific control of
> > applications use of the internet becomes important when you are
> > combating various types of malware be it spyware, trojans, or viruses.
> > While it's true that malware has been slow to spread to the Linux
> > platform it is coming,  and application controls are an important step
> > towards prevention and control.
> 
> Netfilter/iptables is merely just a packet filter with some add-on like NAT.
> In no case netfilter/iptables will replace application proxies.
> The functionality you describe are already provided by various filtering
> application proxies: squid, zorp, etc...
> 
> Many people had all sorts of ideas to make netfilter become more aware
> of the higher level protocols such as HTTP, etc, however most of them
> were bad ideas in my opinion. For instance if you try to filter HTTP URLs
> using netfilter alone with the string match, you'll run into all sorts of troubles.
> What you need in this case is a proper HTTP filtering proxy.
> 
> If you need more information about the caveats of _trying_ to turn netfilter
> into an application proxy, please check the archive, as this question has
> been asked often, and people were told each time that this wasn't the goal
> of netfilter.
> 
> On the other hand, application proxy already play nice with netfilter on the same machine.
> For example, people implement transparent filtering proxies with virus scan
> and HTTP URL blocking and stuff like this using netfilter+squid for example. The same
> can be done with zorp and others. So I believe the netfilter mechanisms facilitating that
> are already in place (REDIRECT,SNAT/DNAT,ULOG to mention just a few...)
> 
> Have a nice day,
> 
> Fabrice.
> --
> Fabrice MARIE
> 
> "Silly hacker, root is for administrators"
>        -Unknown

Actually,  I wasn't asking about application proxies.  Application
proxies are network devices that make network connections on behalf of
another client.  

I was asking about application level filters for iptables,  completely
different.   Meaning,  I don't want to put in a filter on my client
machine (behind a firewall or not),  that says this machine can go to
port 80 on the Internet.  How do you then control which applications can
access port 80?  

I wouldn't want my email program to be able to access port 80 for
instance.  A somewhat misunderstood problem with email clients having
port 80 access has to do with spam email validation.  It's quite simple
for spammers to have their messages "phone home" over port 80. Even just
referencing a specific url on their web server,  one crafted by the spam
software for that email address, is a simple way to unknowingly verify
your email address to the spammer.  

In the personal firewall world,  filters are usually tied to the
application.  It makes more sense for a client machine to have
application level controls.

Proper outbound protection of your client machine is one of the only
ways to control spyware and other malware covertly using your machine.

Joe Saland, CISSP
gideon@gideonolam.co
