From: Jorge Davila <davila@nicaraguaopensource.com>
Subject: Re: [PATCH] Unspecified proto should print as "all" in iptables -L
Date: Mon, 30 Apr 2007 12:17:13 -0600
Message-ID: <web-70582235@bk1.webmaillogin.com>
References: <20070428220206.GA26272@linuxace.com>
	<463524E7.60107@netfilter.org>
	<Pine.LNX.4.61.0704301038100.22744@yvahk01.tjqt.qr>
	<20070430171317.GA6904@linuxace.com>
	<Pine.LNX.4.61.0704301924021.29151@yvahk01.tjqt.qr>
	<20070430173654.GB6904@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Oester <kernel@linuxace.com>,Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070430173654.GB6904@linuxace.com>
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

I was trying to apply a rule

iptables -p 0 -j DROP

to block only the protocol 0. I know now why that rule was not working.

I think that -p 0 must be a reference to the protocol 0 and not to all 
protocols.

Jorge.

On Mon, 30 Apr 2007 10:36:54 -0700
  Phil Oester <kernel@linuxace.com> wrote:
> On Mon, Apr 30, 2007 at 07:25:17PM +0200, Jan Engelhardt wrote:
>> On Apr 30 2007 10:13, Phil Oester wrote:
>> >On Mon, Apr 30, 2007 at 10:38:38AM +0200, Jan Engelhardt wrote:
>> >> Hey btw, how would you go about matching protocol 0 since 0 is 
>>unfortunately
>> >> defined as "all" in iptables?
>> >
>> >I suppose you wouldn't, although AFAIK protocol 0 isn't actively
>> >used.  Have you seen it used in the wild?
>> 
>> /etc/protocols lists ipv6hopbyhop as 0.
>> But also see
>> http://lists.netfilter.org/pipermail/netfilter/2007-April/068496.html
> 
> That is indeed unfortunate, but at this point we can't change the
> meaning of this within iptables without potentially breaking compatibility
> with existing rulesets.  Perhaps someone is using a rule such as this:
> 
>    -p 0 -j DROP
> 
> to drop all traffic to a box.  If we changed it, now it would only block
> protocol 0.
> 
> Sure, far-fetched, but I think our hands are tied to the current 
>definition.
> 
> Phil
> 
> 

Jorge Isaac Davila Lopez
Nicaragua Open Source
davila@nicaraguaopensource.com
