From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Subject: Re: [PATCH] Unspecified proto should print as "all" in iptables -L
Date: Thu, 03 May 2007 19:45:19 +0200
Message-ID: <463A1FAF.5060207@gmx.net>
References: <20070428220206.GA26272@linuxace.com>	<463524E7.60107@netfilter.org>	<Pine.LNX.4.61.0704301038100.22744@yvahk01.tjqt.qr>	<20070430171317.GA6904@linuxace.com>	<Pine.LNX.4.61.0704301924021.29151@yvahk01.tjqt.qr>	<20070430173654.GB6904@linuxace.com>	<web-70582235@bk1.webmaillogin.com>	<20070430200930.GA8187@linuxace.com>	<web-70408147@bk2.webmaillogin.com>
	<463A0EEB.5050402@gmx.net> <20070503173121.GA7998@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jorge Davila <davila@nicaraguaopensource.com>,
	netfilter-devel@lists.netfilter.org,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070503173121.GA7998@linuxace.com>
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

On 03.05.2007 19:31, Phil Oester wrote:
> On Thu, May 03, 2007 at 06:33:47PM +0200, Carl-Daniel Hailfinger wrote:
>> On 03.05.2007 18:16, Jorge Davila wrote:
>>> Well, it's because some users inside the internal networks under my
>>> administration visit http://www.grc.com/ and run the Shields Up! to see
>>> the open ports in the gateways and they see the port 0 open. That was
>>> the reason to apply the rule.
>> Ah cool, that's another datapoint when trying to guess the firewall
>> ruleset. Port 0 not filtered roughly means "default policy is ACCEPT".
>> (Well, not quite. But close.)
> 
> Let's be clear here...we aren't talking about _PORT_ zero.  We're talking
> about _PROTOCOL_ zero.  Can you please elaborate on the specific need
> to filter _PROTOCOL_ zero?

Sorry, my bad. There is no specific need on my side. It's just that
some creative use of nmap enables me to learn more about target systems.
I am entirely happy with the current situation.

Regards,
Carl-Daniel
