From: Fabrice MARIE <fabrice@netfilter.org>
Subject: Re: Application interface
Date: Tue, 24 Jun 2003 16:33:56 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200306241633.56809.fabrice@netfilter.org>
References: <1056408903.3659.13.camel@skinny.gideonolam.com>
Reply-To: fabrice@fma.homelinux.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: gideon olam <gideon@gideonolam.com>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <1056408903.3659.13.camel@skinny.gideonolam.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello,

On Monday 23 June 2003 18:55, gideon olam wrote:
> Is there an interface or mechanism either in place today or planned for
> the future which allows for application level control?  Meaning instead
> of all apps being being allowed to use well known services like http,
> limiting access to a subset of applications?
> I'm interested in Linux's ability to provide some of the personal
> firewall capabilities seen on windows systems.  Specific control of
> applications use of the internet becomes important when you are
> combating various types of malware be it spyware, trojans, or viruses.
> While it's true that malware has been slow to spread to the Linux
> platform it is coming,  and application controls are an important step
> towards prevention and control.

Netfilter/iptables is merely just a packet filter with some add-on like NAT.
In no case netfilter/iptables will replace application proxies.
The functionality you describe are already provided by various filtering
application proxies: squid, zorp, etc...

Many people had all sorts of ideas to make netfilter become more aware
of the higher level protocols such as HTTP, etc, however most of them
were bad ideas in my opinion. For instance if you try to filter HTTP URLs
using netfilter alone with the string match, you'll run into all sorts of troubles.
What you need in this case is a proper HTTP filtering proxy.

If you need more information about the caveats of _trying_ to turn netfilter
into an application proxy, please check the archive, as this question has
been asked often, and people were told each time that this wasn't the goal
of netfilter.

On the other hand, application proxy already play nice with netfilter on the same machine.
For example, people implement transparent filtering proxies with virus scan
and HTTP URL blocking and stuff like this using netfilter+squid for example. The same
can be done with zorp and others. So I believe the netfilter mechanisms facilitating that
are already in place (REDIRECT,SNAT/DNAT,ULOG to mention just a few...)

Have a nice day,

Fabrice.
--
Fabrice MARIE

"Silly hacker, root is for administrators"
       -Unknown
