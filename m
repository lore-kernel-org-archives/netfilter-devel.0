From: Fabrice MARIE <fabrice@netfilter.org>
Subject: using string match - was: my new option calls httpr
Date: Mon, 3 Mar 2003 16:37:30 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200303031637.30785.fabrice@netfilter.org>
References: <618861251.20030301124005@yahoo.es>
Reply-To: fabrice@netfilter.org
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: macadanet@yahoo.es,
   lista de correo netfilter <netfilter-devel@lists.netfilter.org>
In-Reply-To: <618861251.20030301124005@yahoo.es>
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


Hola,

On Saturday 01 March 2003 19:40, macadanet@yahoo.es wrote:
> When I didn't modify -string option. I created a new option -httpr
> (http request).
> I had done a test suite above my network with this patch aplied. In
> Input string on NETFILTER hook, I had a 4 rules:
> iptables -A INPUT -m httpr --httpr '"GET"?"cmd.exe"?"dir"?"HTTP"' -j LOG
> iptables -A INPUT -m httpr --httpr '"GET"?"tftp"?"HTTP"' -j LOG
> iptables -A INPUT -m httpr --httpr '"GET"?"root.exe"?"HTTP"' -j LOG
> iptables -A INPUT -m httpr --httpr '"GET"?"default.ida"?[XNO]*?"HTTP"' -j LOG
> [...]

Don't get me wrong, I'm just trying to explain why you shouldn't be doing this,
please don't take it personally. This is a reminder for a lot of people, not
just you.

All the HTTP rules above will be exploited trivially with Unicode encoding,
or ASCII encoding (for example you can write the URL as GET /cmd.%65x%65
%65 being the hexadecimal ASCII number for 'e'). Look at the tool whisker
for more informations on IDS evasion techniques, a lot of them are applicable
to the string match.

Using such encoding for example, the string match (with or without regexp support) will not match,
and if you rely on this match as a strong security layer to stop worms or hand exploitation for instance,
then you're in trouble. Now if you think that it's difficult to browse normally
using such obfuscation, think again, since it would be trivial to write such
a proxy (provided it hasn't already been done).

Another reason why I wouldn't want to use this rule is that it will match the string
_anywhere_ in the packet. As such, if you are trying to browse an archived
version of this email, your firewall would drop the legitimate web page content.
It wouldn't even drop the HTTP request, it would erase content from the page, and
most probably kill your HTTP connection in the middle.

As Patrick has mentioned, there are _many_ reasons why you should not be doing
this. And regexp is just one of them. We will never repeat enough times, that the proper
way of filtering a high level protocol is to use an Application Proxy. In your case,
what you really need is an HTTP filtering proxy. Look at Squid or Zorp. Not sure
for Squid, but Zorp most probably will support regexps since you write the rules in python..

There was a thread some time ago highlighting speed as a reason to shift away from
a filtering proxy. I do not buy the arguments (no offense (-: ) and think that there
must be a way to get a proxy fast enough... If people have such a bandwith or such
a need for high security, then it means they have the budget for faster machine that can
run the proxy fast enough. So far, the only two reasons I understand to shift
away from proxies are
1- when there is no (free) proxy available for the protocol mentioned
   (packet filters are better that no filtering at all)
2- when budgets are too limited, and one cannot get a machine fast enough
   for the proxy.

string match is probably useful for information purpose, information gathering or stuff
like this (part of an IDS for example), where taking a hard action on the packet is not necessary.
Whenever you want to take a concrete action on the packet based on a string match decision,
most of the times you're jeopardizing your security _or/and_ the usability of your network.
string match is a nice one, but it _must_ be used with eyes wide open,
as it's easy to shoot yourself in the foot ;-)

Have a nice day,

Fabrice.
--
Fabrice MARIE

"Silly hacker, root is for administrators"
       -Unknown
