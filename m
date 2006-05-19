From: Matt Ayres <matta@tektonic.net>
Subject: Re: Re: Panic in ipt_do_table with 2.6.16.13-xen
Date: Thu, 18 May 2006 20:16:45 -0400
Message-ID: <446D0E6D.2080600@tektonic.net>
References: <4468BE70.7030802@tektonic.net> <4468D613.20309@trash.net>
	<44691669.4080903@tektonic.net>
	<Pine.LNX.4.64.0605152331140.10964@d.namei>
	<4469D84F.8080709@tektonic.net>
	<Pine.LNX.4.64.0605161127030.16379@d.namei>
	<446D0A0D.5090608@tektonic.net>
	<Pine.LNX.4.64.0605182002330.6528@d.namei>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <xen-devel-bounces@lists.xensource.com>
To: James Morris <jmorris@namei.org>
In-Reply-To: <Pine.LNX.4.64.0605182002330.6528@d.namei>
List-Unsubscribe: <http://lists.xensource.com/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
List-Id: netfilter-devel.vger.kernel.org



James Morris wrote:
> On Thu, 18 May 2006, Matt Ayres wrote:
> 
>>> I'm trying to suggest eliminating this driver & possible interaction with
>>> Xen network changes as a cause.  If you can find a different type of NIC to
>>> plug in and use, or even try and change all of the params for the tg3 with
>>> ethtool, it'll help.
>>>
>> Hi,
>>
>> Thank you for the assistance. Which parameters do you suggest changing?
>> TSO/flow control off?
> 
> Yep, anything.

Ok, "ethtool -K eth0 rx off tx off sg off tso off" should have turned it 
  all off.

> 
>> iptables -L -v just shows 2 rules per Virtual Machine for accounting. This
>> averages about 100 rules in the FORWARD chain.  Example:
> 
> Do you know if the problem starts appearing after a certain number of 
> hosts?
> 

No... I have some servers that are running just 2.6.16-xen (no bugfix 
patches) for 30 days without a problem, some of these have rulesets 
larger than the ones that crash daily. I'd estimate this affects 90% of 
my servers, just some reboot daily and others can make it to 7-10 days.

Thanks,
Matt
