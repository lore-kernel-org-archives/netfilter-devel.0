From: Jorge Davila <davila@nicaraguaopensource.com>
Subject: Re: [PATCH] Unspecified proto should print as "all" in iptables -L
Date: Thu, 03 May 2007 10:16:05 -0600
Message-ID: <web-70408147@bk2.webmaillogin.com>
References: <20070428220206.GA26272@linuxace.com>
	<463524E7.60107@netfilter.org>
	<Pine.LNX.4.61.0704301038100.22744@yvahk01.tjqt.qr>
	<20070430171317.GA6904@linuxace.com>
	<Pine.LNX.4.61.0704301924021.29151@yvahk01.tjqt.qr>
	<20070430173654.GB6904@linuxace.com>
	<web-70582235@bk1.webmaillogin.com>
	<20070430200930.GA8187@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070430200930.GA8187@linuxace.com>
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

Sorry for the delay in answering your question ...

Well, it's because some users inside the internal networks under my 
administration visit http://www.grc.com/ and run the Shields Up! to see the 
open ports in the gateways and they see the port 0 open. That was the reason 
to apply the rule.

Jorge.

On Mon, 30 Apr 2007 13:09:30 -0700
  Phil Oester <kernel@linuxace.com> wrote:
> On Mon, Apr 30, 2007 at 12:17:13PM -0600, Jorge Davila wrote:
>> I was trying to apply a rule
>> 
>> iptables -p 0 -j DROP
>> 
>> to block only the protocol 0. I know now why that rule was not working.
>> 
>> I think that -p 0 must be a reference to the protocol 0 and not to all 
>> protocols.
>> 
>> Jorge.
> 
> Which application uses protocol 0?  Or is this a custom app you wrote?
> 
> Phil
> 

Jorge Isaac Davila Lopez
Nicaragua Open Source
davila@nicaraguaopensource.com
