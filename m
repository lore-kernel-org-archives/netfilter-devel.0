From: Amin Azez <azez@ufomechanic.net>
Subject: Re: new code; iptables-xml for iptables package.
Date: Fri, 10 Nov 2006 15:57:04 +0000
Message-ID: <4554A150.8040300@ufomechanic.net>
References: <455311B5.5000600@ufomechanic.net>	<455374BE.9050507@trash.net>	<455457C8.4030205@ufomechanic.net>	<45547982.2070606@trash.net>	<45547E94.1040100@ufomechanic.net>	<455483D9.6090003@trash.net>	<45548CD2.5090407@ufomechanic.net>
	<45548FC7.1080702@trash.net>	<455493CB.4020501@ufomechanic.net>
	<455496A9.1050208@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <455496A9.1050208@trash.net>
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

* Patrick McHardy wrote, On 10/11/06 15:11:
> Amin Azez wrote:
>> In trying to work out why it works at all, I discover that
>> *text++ is not the same as (*text)++; both of which are wrong in this case.
>>
>> While we are at it we should make that compare at the top of the same
>> function be >=127 not >127
> 
> OK, both fixed and applied. Please send potential fixes or changes as
> patches against current SVN.

OK, Thanks.

To what were they applied? They're not in current SVN according to:
http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/iptables/

Sam
